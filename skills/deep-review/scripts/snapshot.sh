#!/bin/sh
# Prints a commit of the working tree, untracked files included, leaving the index alone.
# With a name, also saves it as refs/worktree/deep-review/<name>.
set -e
i=$(mktemp -u "${TMPDIR:-/tmp}/deep-review-index-XXXXXX")
trap 'rm -f "$i"' EXIT
cp "$(git rev-parse --git-path index)" "$i" 2>/dev/null || :
GIT_INDEX_FILE=$i git add -A
c=$(git commit-tree --no-gpg-sign -m deep-review "$(GIT_INDEX_FILE=$i git write-tree)")
[ -z "$1" ] || git update-ref "refs/worktree/deep-review/$1" "$c"
echo "$c"
