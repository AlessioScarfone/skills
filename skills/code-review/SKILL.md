---
name: code-review
description: Reviews local changes, a specified diff, or a GitHub/GitLab pull/merge request for bugs, logic errors, security vulnerabilities, code quality issues, and project-convention violations, using confidence-based filtering to report only verified, high-impact issues. Use when the user asks to review code, check a diff, branch, PR or MR, audit recent changes, or sanity-check work before pushing. Do not use for implementing features, writing tests, refactoring, or applying fixes.
---

# Code Review

Act as a hostile reviewer. Find real defects in the diff. Suggest fixes only; never apply them.
 
## Step 1: Determine Scope

Pick the input mode, then collect the diff and intent as described in "Gathering Context".

1. User gives a PR/MR (URL, number, or branch): use "Remote PR/MR input".
2. User names files, a branch, or a commit range: use "Local git" with that scope (e.g., `git diff main...HEAD`).
3. Otherwise review all local changes, staged and unstaged: `git diff HEAD`.
4. Establish the intent following "Determine Intent". Read `AGENTS.md` or contribution guidelines for project conventions.

## Determine Intent

Intent is what the change claims to implement. Use exactly one primary source:

- **PR/MR provided**: the description written by its author is the primary source, together with title, linked issues, and commit messages. Fetch it with the provider CLI (see "Remote PR/MR input"). Use the user message only for extra focus areas, not to override the PR/MR intent.
- **No PR/MR provided**: extract the intent from the user's initial message. Add commit messages and spec/plan files referenced by the change only to fill gaps.

State the intent in one or two sentences at the start of the report. Validate the code against it in Step 2.

## Gathering Context

On any failure, follow "Error Handling".

### Local git

```bash
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD)  # e.g. origin/main
git branch --show-current
git log "$BASE"..HEAD --oneline
git diff "$BASE"...HEAD --stat
git diff "$BASE"...HEAD -- <relevant files>
```

Start from `--stat` and read the full diff only for relevant files; skip lockfiles and generated files. For uncommitted work use `git diff HEAD`.

### Remote PR/MR input

Detect the provider from the URL or `git remote get-url origin`, check the CLI exists (`command -v glab gh`), and use it instead of local git:

```bash
# GitLab
glab mr view <id|url|branch>   # title, description, source/target branch, linked issues
glab mr diff <id|url|branch>   # full diff

# GitHub
gh pr view <id|url|branch> --json title,body,headRefName,baseRefName
gh pr diff <id|url|branch>     # full diff
```

Other providers (Bitbucket, Azure DevOps, etc.) have no CLI here: go to "Error Handling".

A diff alone is not enough to trace a defect. When the checked-out branch is not the PR/MR source branch, fetch it and read surrounding code without switching branches: `git fetch origin <source>` then `git show origin/<source>:<path>`.

## Step 2: Find and Verify Issues

For each candidate issue:

1. Check the diff against the intent first: report behaviour the intent requires but the code does not implement, code that contradicts it, and unrelated changes outside its scope. Treat a PR/MR description that disagrees with the code as a finding.
2. Reproduce before reporting. Trace the exact path through the code, or sketch the failing test case.
3. Identify the file, the line, and the input or state that triggers it.
4. Assign a severity:
   - **CRITICAL**: data loss, security, breaks in production.
   - **MAJOR**: wrong behaviour a user will hit.
   - **MINOR**: works, might bite later.
   - **NIT**: style.
5. Assign a confidence score using the scale below.

Ignore pre-existing issues the diff does not touch.
 
## Confidence Scoring

- **0**: False positive that does not stand up to scrutiny, or a pre-existing issue.
- **25**: Might be real, might be a false positive. Stylistic issues not called out in project guidelines land here.
- **50**: Real but a nitpick, or rarely hit in practice.
- **75**: Double-checked, very likely hit in practice, directly impacts functionality or violates a stated guideline.
- **100**: Confirmed by direct evidence; will happen frequently.

Reporting rules:

- Report reproduced issues with confidence ≥ 80.
- Mark issues that cannot be reproduced as UNVERIFIED. List them only if severity is CRITICAL or MAJOR; drop the rest.

## Step 3: Report

Structure the output as:

1. **Scope**: what was reviewed (diff command, files, or PR/MR id) and the intent with its source (PR/MR description, user message, or spec).
2. **Findings**: grouped by severity (CRITICAL, MAJOR, MINOR, NIT). For each finding:
   - Description and confidence score
   - `file:line` and the triggering input or state
   - Guideline reference or bug explanation
   - Concrete fix suggestion
3. **Unverified**: CRITICAL/MAJOR candidates that could not be reproduced.
4. **Assumptions**: anything assumed, kept separate from findings.

If nothing above MINOR is found, state that explicitly with a brief summary.

## Error Handling

- **Not a git repository**: ask the user which files or diff to review.
- **Base branch not detected** (`origin/HEAD` unset): ask the user for the base branch.
- **CLI missing, unauthenticated, or failing**, or **provider without a CLI**: tell the user, then use local `git` with the source and target branches: `git fetch origin <source> <target>`, `git log origin/<target>..origin/<source> --oneline`, `git diff origin/<target>...origin/<source>`.
- **Branches unknown or not fetchable**: ask the user for the PR/MR source and target branch, or for its pasted diff and description.
- **Empty diff**: report that no changes were found and ask for an explicit scope (branch, commit range, or files).
- **No spec or intent found**: review for correctness and project conventions only, and record the missing intent under Assumptions. For a PR/MR with an empty description, fall back to the user message, then commits.
- **Diff too large to review thoroughly**: say so, prioritise security-sensitive and core-logic files, and list the files skipped.