#!/usr/bin/env bash
# Usage: rewrite-authors.sh <repo-path> <new-name> <new-email> [old-email]
# Rewrites author and committer of every commit on all branches to <new-name> <new-email>.
# If [old-email] is given, only commits whose author or committer email matches it are changed.
# Creates a mirror backup next to the repo, sets repo-local user.name/user.email (never global),
# and removes the refs/original safety refs. Does NOT push.
set -euo pipefail

repo="${1:-}"; name="${2:-}"; email="${3:-}"; old="${4:-}"
if [ -z "$repo" ] || [ -z "$name" ] || [ -z "$email" ]; then
  echo "ERROR: usage: rewrite-authors.sh <repo-path> <new-name> <new-email> [old-email]" >&2
  exit 1
fi
if ! git -C "$repo" rev-parse --verify -q HEAD >/dev/null; then
  echo "ERROR: repository has no commits yet" >&2
  exit 1
fi
if [ -n "$(git -C "$repo" status --porcelain --untracked-files=no)" ]; then
  echo "ERROR: working tree has uncommitted changes to tracked files; commit or stash them first" >&2
  exit 1
fi

repo="$(cd "$repo" && pwd)"
backup="$repo-backup.git"
if [ -e "$backup" ]; then
  echo "ERROR: $backup already exists; remove or rename it first" >&2
  exit 1
fi
git clone -q --mirror "$repo" "$backup"
echo "Backup created: $backup"

git -C "$repo" config --local user.name "$name"
git -C "$repo" config --local user.email "$email"

# Remote-only branches need a local branch, otherwise filter-branch would skip them.
git -C "$repo" for-each-ref --format='%(refname:strip=3)' refs/remotes/origin | while read -r b; do
  if [ "$b" != "HEAD" ] && ! git -C "$repo" show-ref -q --verify "refs/heads/$b"; then
    git -C "$repo" branch "$b" "origin/$b"
  fi
done

export FILTER_BRANCH_SQUELCH_WARNING=1 NEW_NAME="$name" NEW_EMAIL="$email" OLD_EMAIL="$old"
git -C "$repo" filter-branch -f --env-filter '
if [ -z "$OLD_EMAIL" ] || [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
  export GIT_AUTHOR_NAME="$NEW_NAME" GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
if [ -z "$OLD_EMAIL" ] || [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]; then
  export GIT_COMMITTER_NAME="$NEW_NAME" GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
' -- --branches --tags >/dev/null

git -C "$repo" for-each-ref --format='%(refname)' refs/original | while read -r ref; do
  git -C "$repo" update-ref -d "$ref"
done

echo "Rewrite done. Identities now on branches:"
git -C "$repo" log --branches --format='%an <%ae> | %cn <%ce>' | sort | uniq -c
echo "Next: after the user confirms, run: git -C \"$repo\" push --force-with-lease --all origin (and --tags if tags exist)."
