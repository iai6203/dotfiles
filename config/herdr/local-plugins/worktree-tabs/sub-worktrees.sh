#!/bin/bash
# Create sub-repository worktrees inside a new meta-repository worktree.
# Usage: sub-worktrees.sh <source-root> <checkout> <branch>
# Prints each sub-repository whose worktree it created, one per line; all
# diagnostics go to stderr.
set -euo pipefail

# Resolve both roots so `git -C <repo>` never reinterprets a relative path.
source_root=$(cd "$1" && pwd -P)
checkout=$(cd "$2" && pwd -P)
branch=$3
manifest="$checkout/.herdr-worktree.json"

# Plain single repositories have no manifest and need no sub-worktrees.
[[ -f $manifest ]] || exit 0

status=0
warn() {
    printf 'worktree-tabs: %s\n' "$*" >&2
    status=1
}

# Read the lists up front so a malformed manifest fails loudly instead of
# vanishing inside a process substitution.
if ! jq -e '
    (.repos // []) as $r | (.copy // []) as $c
    | ($r | type == "array" and all(type == "string"))
      and ($c | type == "array" and all(type == "string"))
' "$manifest" > /dev/null; then
    printf 'worktree-tabs: %s must hold string arrays "repos" and "copy"\n' "$manifest" >&2
    exit 1
fi
repos=$(jq -r '.repos // [] | .[]' "$manifest")
copies=$(jq -r '.copy // [] | .[]' "$manifest")

while IFS= read -r repo; do
    [[ -n $repo ]] || continue
    src="$source_root/$repo"
    dest="$checkout/$repo"

    # The entry must be a repository root itself; otherwise Git would resolve
    # the enclosing meta repository and add a worktree of that instead.
    if [[ ! -d $src ]] \
        || [[ $(git -C "$src" rev-parse --show-toplevel 2> /dev/null) != "$(cd "$src" && pwd -P)" ]]; then
        warn "$src is not a Git repository root"
        continue
    fi
    if [[ -e $dest ]]; then
        warn "$dest already exists"
        continue
    fi

    if git -C "$src" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$src" worktree add --quiet "$dest" "$branch" >&2 || {
            warn "failed to add $repo worktree"
            continue
        }
    else
        # Branch from the remote default branch without tracking it, so a plain
        # `git push` never targets the default branch. A stale origin/HEAD that
        # points at a deleted branch falls back to HEAD.
        base=$(git -C "$src" symbolic-ref --quiet --short refs/remotes/origin/HEAD || true)
        if [[ -z $base ]] || ! git -C "$src" rev-parse --verify --quiet "$base^{commit}" > /dev/null; then
            base=HEAD
        fi
        git -C "$src" worktree add --quiet --no-track -b "$branch" "$dest" "$base" >&2 || {
            warn "failed to add $repo worktree from $base"
            continue
        }
    fi
    printf '%s\n' "$repo"
done <<< "$repos"

# Copy untracked files such as .env that a fresh checkout lacks.
while IFS= read -r path; do
    [[ -n $path ]] || continue
    src="$source_root/$path"
    dest="$checkout/$path"
    parent=$(dirname "$dest")

    if [[ ! -f $src ]]; then
        warn "copy source $src does not exist"
        continue
    fi
    if [[ ! -d $parent ]]; then
        warn "copy target directory $parent does not exist"
        continue
    fi
    # Refuse targets that resolve outside the checkout, e.g. through a symlink.
    if [[ $(cd "$parent" && pwd -P)/ != "$checkout"/* ]]; then
        warn "copy target $dest resolves outside $checkout"
        continue
    fi
    # Claim the target atomically so an existing file is never overwritten.
    if ! (set -C; : > "$dest") 2> /dev/null; then
        [[ -e $dest ]] || warn "cannot create $dest"
        continue
    fi
    cp -p "$src" "$dest" || warn "failed to copy $path"
done <<< "$copies"

exit "$status"
