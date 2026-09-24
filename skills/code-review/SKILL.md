---
name: code-review
description: Reviews local changes or a specified diff for bugs, logic errors, security vulnerabilities, code quality issues, and project-convention violations, using confidence-based filtering to report only verified, high-impact issues. Use when the user asks to review code, check a diff or branch, audit recent changes, or sanity-check work before pushing. Do not use for implementing features, writing tests, refactoring, or applying fixes.
---

# Code Review

Act as a hostile reviewer. Find real defects in the diff. Suggest fixes only; never apply them.
 
## Step 1: Determine Scope

1. Default to all local changes, staged and unstaged: run `git diff HEAD`.
2. If the user names files, a branch, a commit range, or a PR, review that instead (e.g., `git diff main...HEAD`).
3. Gather the intent the change claims to implement, in this order: the user message, the PR or commit description, spec/plan files referenced by the change. Read `AGENTS.md` or contribution guidelines for project conventions.
 
## Step 2: Find and Verify Issues

For each candidate issue:

1. Reproduce before reporting. Trace the exact path through the code, or sketch the failing test case.
2. Identify the file, the line, and the input or state that triggers it.
3. Assign a severity:
   - **CRITICAL**: data loss, security, breaks in production.
   - **MAJOR**: wrong behaviour a user will hit.
   - **MINOR**: works, might bite later.
   - **NIT**: style.
4. Assign a confidence score using the scale below.

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

1. **Scope**: what was reviewed (diff command or files, and the spec/context used).
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
- **Empty diff**: report that no changes were found and ask for an explicit scope (branch, commit range, or files).
- **No spec or intent found**: review for correctness and project conventions only, and record the missing spec under Assumptions.
- **Diff too large to review thoroughly**: say so, prioritise security-sensitive and core-logic files, and list the files skipped.