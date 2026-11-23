#!/bin/bash
# Create sub-repository worktrees inside a new meta-repository worktree.
# Usage: sub-worktrees.sh <source-root> <checkout> <branch>
set -euo pipefail

source_root=$1
checkout=$2
branch=$3
manifest="$checkout/.herdr-worktree.json"

# Plain single repositories have no manifest and need no sub-worktrees.
[[ -f $manifest ]] || exit 0

status=0
warn() {
    printf 'worktree-tabs: %s\n' "$*" >&2
    status=1
}

while IFS= read -r repo; do
    src="$source_root/$repo"
    dest="$checkout/$repo"

    if ! git -C "$src" rev-parse --git-dir > /dev/null 2>&1; then
        warn "$src is not a Git repository"
        continue
    fi
    if [[ -e $dest ]]; then
        warn "$dest already exists"
        continue
    fi

    if git -C "$src" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$src" worktree add --quiet "$dest" "$branch" || warn "failed to add $repo worktree"
    else
        # Branch from the remote default branch without tracking it, so a plain
        # `git push` never targets the default branch.
        base=$(git -C "$src" symbolic-ref --quiet --short refs/remotes/origin/HEAD || echo HEAD)
        git -C "$src" worktree add --quiet --no-track -b "$branch" "$dest" "$base" \
            || warn "failed to add $repo worktree from $base"
    fi
done < <(jq -r '.repos // [] | .[]' "$manifest")

# Copy untracked files such as .env that a fresh checkout lacks.
while IFS= read -r path; do
    src="$source_root/$path"
    dest="$checkout/$path"

    if [[ ! -f $src ]]; then
        warn "copy source $src does not exist"
    elif [[ ! -e $dest && -d $(dirname "$dest") ]]; then
        cp -p "$src" "$dest"
    fi
done < <(jq -r '.copy // [] | .[]' "$manifest")

exit "$status"
