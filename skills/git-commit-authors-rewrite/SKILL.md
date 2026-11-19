---
name: git-commit-authors-rewrite
description: Audits which author and committer identities (name and email) appear in a git repository's commits and rewrites them to a chosen identity across all branches, with a mirror backup, repo-local git config and a confirmed force-push. Use when asked to check which emails or users made commits, fix commits made with a wrong or work email, or change the author of all commits in a repo. Do not use for amending a single recent commit, editing commit messages, removing secrets or large files from history, or squashing and rebasing commits.
argument-hint: repository-name
---

# Git Commit Authors: Audit and Rewrite

## Procedures

**Step 1: Audit the identities**
1. Run `bash scripts/list-authors.sh <repo-path>` for each target repository. Run it from the skill directory or use its absolute path.
2. Report to the user, per repository: author and committer identities with commit counts, the branches, and the local and global `user.email`.
3. Flag commits whose committer is `noreply@github.com` (made through the GitHub web UI); these are rewritten like any other.
4. If the script reports no commits, stop for that repository: there is nothing to rewrite. Tell the user to set the identity first with `git config --local user.name` and `git config --local user.email`, then commit.

**Step 2: Confirm the scope**
1. Rewriting changes every commit hash and requires a force-push. Use `ask_user` to confirm: target repositories, new name and email, whether to rewrite all identities or only one old email, and whether to push.
2. Skip the question only when the user already stated all of these explicitly.
3. Never change the global git config unless the user explicitly asks. If they ask for specific repositories only, change only repo-local config.

**Step 3: Rewrite**
1. Run `bash scripts/rewrite-authors.sh <repo-path> "<new-name>" "<new-email>" [old-email]` for each repository. Omit `[old-email]` to rewrite every identity.
2. The script creates a mirror backup `<repo-path>-backup.git`, sets repo-local `user.name` and `user.email`, creates local branches for remote-only branches, rewrites all local branches and tags, and deletes the `refs/original` safety refs.
3. Check the printed identity summary shows only the new identity (or no remaining old email).

**Step 4: Verify locally**
1. Run `git -C <repo-path> log --branches --format='%ae | %ce' | sort | uniq -c` and confirm only the expected emails remain.
2. Run `git -C <repo-path> config --show-origin user.email` and confirm it comes from `.git/config`.

**Step 5: Push (only if the user asked for it)**
1. Run `git -C <repo-path> push --force-with-lease --all origin`, plus `--tags` if tags exist.
2. Run `git -C <repo-path> ls-remote --heads origin` and confirm every branch hash matches the local branch.
3. Do not push to repositories or remotes the user did not name.

**Step 6: Clean up**
1. Keep the `<repo-path>-backup.git` directories until the user confirms the result, then delete them only when the user asks.

## Error Handling
* If the script reports uncommitted changes, ask the user to commit or stash them, then re-run.
* If the script reports the backup already exists, ask before deleting it; do not overwrite it.
* If `--force-with-lease` is rejected with "stale info", run `git fetch origin` and re-check that nobody pushed new commits. Use plain `--force` only after the user confirms.
* If the push is rejected by branch protection, report it; do not try to bypass it.
* Commit messages are not modified, so trailers such as `Co-authored-by:` keep their old identities. Tell the user if any exist (`git log --branches --grep='Co-authored-by'`).
* Collaborators with existing clones must re-clone or run `git fetch && git reset --hard origin/<branch>` after a force-push; mention this when the remote is shared.
* To restore the original history, push from the backup: `git -C <repo-path>-backup.git push --mirror <remote-url>`.
