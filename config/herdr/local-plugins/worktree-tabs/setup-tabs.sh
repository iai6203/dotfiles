#!/bin/bash
set -euo pipefail

# The Herdr server may start without Homebrew (macOS) or Linuxbrew (Linux/WSL) in its PATH.
export PATH="$PATH:/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin"
herdr=${HERDR_BIN_PATH:?}
event=${HERDR_PLUGIN_EVENT_JSON:?}
workspace=$(jq -er '.data.workspace.workspace_id' <<< "$event")
initial_tab=$(jq -er '.data.workspace.active_tab_id' <<< "$event")
checkout=$(jq -er '.data.worktree.path' <<< "$event")
branch=$(jq -er '.data.worktree.branch' <<< "$event")
source_root=$(jq -er '.data.workspace.worktree.repo_root' <<< "$event")

# Prepare sub-repository worktrees before the panes start, but still open the
# tabs when a sub-repository fails; the failure is reported via the exit code.
# The helper prints only the sub-repositories whose worktrees it created.
sub_status=0
created_repos=$(/bin/bash "$(dirname "$0")/sub-worktrees.sh" "$source_root" "$checkout" "$branch") \
    || sub_status=$?

run_in_pane() {
    local pane=$1 app=$2 deadline=$((SECONDS + 10))

    # A newly allocated pane may not have handed the PTY to its shell yet.
    while (( SECONDS < deadline )); do
        if "$herdr" pane process-info --pane "$pane" | jq -e '
            .result.process_info
            | .shell_pid != null and .shell_pid == .foreground_process_group_id
        ' > /dev/null; then
            "$herdr" pane run "$pane" "$app" > /dev/null
            return
        fi
        sleep 0.1
    done

    printf 'worktree-tabs: shell in %s was not ready to run %s\n' "$pane" "$app" >&2
    return 1
}

initial_pane=$("$herdr" pane list --workspace "$workspace" | jq -er --arg tab "$initial_tab" '
    [.result.panes[] | select(.tab_id == $tab)]
    | if length == 1 then .[0].pane_id else error("expected one initial pane") end
')
"$herdr" tab rename "$initial_tab" nvim > /dev/null

# Meta repositories get one equal-width nvim pane per sub-repository worktree
# created for this branch; anything else keeps a single nvim at the checkout root.
repos=()
while IFS= read -r repo; do
    if [[ -n $repo ]]; then repos+=("$repo"); fi
done <<< "$created_repos"

if (( ${#repos[@]} == 0 )); then
    run_in_pane "$initial_pane" nvim
else
    nvim_panes=("$initial_pane")
    pane=$initial_pane
    for (( i = 1; i < ${#repos[@]}; i++ )); do
        # The ratio is the share kept by the pane being split, so 1/remaining
        # leaves every pane with the same width.
        ratio=$(LC_ALL=C awk -v n="$(( ${#repos[@]} - i + 1 ))" 'BEGIN { printf "%.4f", 1 / n }')
        pane=$("$herdr" pane split "$pane" --direction right --ratio "$ratio" \
            --cwd "$checkout/${repos[i]}" --no-focus | jq -er '.result.pane.pane_id')
        nvim_panes+=("$pane")
    done

    # Split first and start nvim afterwards so no nvim is resized while starting.
    # The initial pane opened at the checkout root, so it moves into its repository.
    run_in_pane "$initial_pane" "cd -- $(printf '%q' "$checkout/${repos[0]}") && nvim"
    for (( i = 1; i < ${#repos[@]}; i++ )); do
        run_in_pane "${nvim_panes[i]}" nvim
    done
fi

claude_pane=$("$herdr" tab create --workspace "$workspace" --cwd "$checkout" --label agents --no-focus \
    | jq -er '.result.root_pane.pane_id')
omp_pane=$("$herdr" pane split "$claude_pane" --direction right --ratio 0.5 --cwd "$checkout" --no-focus \
    | jq -er '.result.pane.pane_id')
run_in_pane "$claude_pane" claude
run_in_pane "$omp_pane" omp

"$herdr" tab create --workspace "$workspace" --cwd "$checkout" --label terminal --no-focus > /dev/null

exit "$sub_status"
