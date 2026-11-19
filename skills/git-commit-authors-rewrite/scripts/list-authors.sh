#!/usr/bin/env bash
# Usage: list-authors.sh <repo-path>
# Prints the author and committer identities found on real branches (local and remote-tracking),
# with commit counts, plus the git config identity that would be used for new commits.
set -euo pipefail

repo="${1:-}"
if [ -z "$repo" ] || ! git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: pass the path of a git repository as the first argument" >&2
  exit 1
fi

if [ -z "$(git -C "$repo" for-each-ref refs/heads refs/remotes)" ] || ! git -C "$repo" rev-parse --verify -q HEAD >/dev/null; then
  echo "ERROR: repository has no commits yet (nothing to inspect or rewrite)" >&2
  exit 1
fi

echo "== Authors (count | name <email>)"
git -C "$repo" log --branches --remotes --format='%an <%ae>' | sort | uniq -c | sort -rn
echo
echo "== Committers (count | name <email>)"
git -C "$repo" log --branches --remotes --format='%cn <%ce>' | sort | uniq -c | sort -rn
echo
echo "== Branches"
git -C "$repo" branch -a --format='%(refname:short)'
echo
echo "== Config identity for new commits"
echo "local : $(git -C "$repo" config --local user.name || true) <$(git -C "$repo" config --local user.email || true)>"
echo "global: $(git -C "$repo" config --global user.name || true) <$(git -C "$repo" config --global user.email || true)>"
