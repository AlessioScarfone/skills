---
name: pr-description
description: Generate pull/merge request titles and descriptions from diffs and context. Use when creating a PR, writing PR description, drafting merge request, or summarizing changes for review. Do not use for code review, commit message generation, or changelog writing.
metadata:
  credits:
    skill: pr
    author: Matt Pocock
    note: Inspired by Matt Pocock's original PR skill
    url: "https://github.com/mattpocock/skills/blob/main/skills/engineering/pr/SKILL.md"
---

# PR Description

Generate clear, structured PR/MR titles and descriptions from git diff, branch context, and linked issues.
Output a single code block with all the content, using a four-backtick fence (not three) because the body can contain nested fenced blocks (mermaid, diff, text). Use markdown formatting for readability.

## When to Use

- User is about to open a PR/MR
- User asks for a PR description, title, or summary of changes
- User wants to document what a branch does for reviewers

## Workflow

1. **Gather context**: Current branch, base branch, `git diff`, `git log`, commit messages. If the user provides an existing PR/MR (URL, number, or branch), fetch it with the provider CLI (`glab`, `gh`); see "Gathering Context" and "Error Handling"
2. **Identify scope**: Files changed, types of change (feature, fix, refactor, docs)
3. **Check for tickets**: Extract ticket keys (see "Ticket keys")
4. **Title**: Short, imperative, conventional (e.g. `Add OAuth2 login`)
5. **Description**: Summary, what changed, why. Skip all preambles and keep prose brief. Read `references/content-guidelines.md` to pick the Summary diagram, diff-sketch, or tree.
6. **Merge Danger**: Select one risk level, then classify the door and blast radius (see "Classifying Merge Danger" under "What to Include").

## Template

Use this template for writing the PR/MR body:

```markdown
# <Title>

## 💡 Summary: What's Changing & Why?

<1-3 sentences: what this PR/MR changes, why, and the key changes>

Related ticket(s): <DFE-123>

<diagram, diff-sketch, or tree>

## 🧪 Testing & Validation

<testing performed to safely deliver this change to production>

<screenshot, test output, or other evidence>

## 🧨 Merge Danger

Risk Level:

- [ ] Low
- [ ] Medium
- [ ] High

**Door:** <one-way (hard to revert) or two-way (easy to revert)>

<optional: why it is hard or easy to revert>

**Blast Radius:** <one word for what is affected, e.g. Consumers, UI, Data>

<optional: what could break and who would notice>
```

Placeholders use `<...>`. Replace every placeholder; never leave `<...>` text in the output. For `Related ticket(s)`, output only the bare ticket key (e.g. `DFE-123`, see "Ticket keys") with no `Fixes`/`Relates to` prefix; separate multiple keys with commas and omit the line when there is none. Omit the evidence line of Testing & Validation when none exists. Never invent test results: when no testing evidence is available in the diff, commits, or user input, write `Not verified` or ask the user.

## Content description guidelines

Read `references/content-guidelines.md` before writing the Summary diagram, diff-sketch, or tree. It lists which view to use (pseudocode, call tree, component tree, file tree, Mermaid, diff, full block) for each kind of change.

## What to Include

**Always**:
- Summary that explains intent, not just file names
- List of meaningful changes (not every file)
- Related ticket key if any
- Merge Danger section (risk level, door, blast radius), kept to one line each for trivial changes

**When relevant**:
- Breaking changes section
- Screenshots for UI changes
- Migration notes for DB/schema changes
- Performance or security notes

**Avoid**:
- Copy-pasting full diff into description
- Vague summaries ("updated stuff")

### Testing & Validation

Concrete evidence that the change works. Show a before and after.

Screenshots are S-tier - when the environment is set up for it and the change is visual.

Execution-based evidence is A-tier. Test results, console output. Show the exact test that now fails and passes, using pseudocode.

### Classifying Merge Danger

Mark exactly one risk level with `[x]`:

- **Low**: two-way door and narrow blast radius (e.g. docs, tests, isolated internal change)
- **Medium**: two-way door but wide blast radius, or one-way door with a narrow one
- **High**: one-way door and wide blast radius (e.g. destructive migration, breaking change for consumers)

Describe whether it's a one-way or two-way door. You can walk back through two-way doors, but not one-way doors. A PR/MR that is cheap to roll back is lower risk. Changes that involve destructive actions or hard-to-reverse decisions are one-way doors.

The blast radius is the potential impact or scope of the changes introduced by this PR/MR. Consider all possibilities. Examples are layout shift, breakages for consumers, mobile responsiveness, etc.

## Gathering Context

If the user provides an existing PR/MR (URL, number, or branch), start with "Remote PR/MR input". Otherwise use "Local git". On any failure, follow "Error Handling".

### Local git

```bash
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD)  # e.g. origin/main
git branch --show-current
git log "$BASE"..HEAD --oneline
git diff "$BASE"...HEAD --stat
git diff "$BASE"...HEAD -- <relevant files>
```

Start from `--stat` and read the full diff only for relevant files; skip lockfiles and generated files. If the branch has no commits ahead of the base, use `git diff HEAD` (uncommitted) and `git diff --staged`.

Infer scope from changed paths (e.g. `src/auth/` → scope "auth"). Use commit messages to reinforce intent.

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

### Ticket keys

```bash
{ git branch --show-current; git log "$BASE"..HEAD --oneline; } | grep -oiE '[a-z][a-z0-9]+-[0-9]+' | tr a-z A-Z | sort -u
```

Branch names are often lowercase (`feature/dfe-123-foo`), so match case-insensitively and output uppercase. Discard false positives such as `UTF-8` or `SHA-256`; prefer the prefix that appears in the branch name. For a remote PR/MR, apply the same pattern to the source branch name and title.

## Error Handling

- **Base branch not detected** (`origin/HEAD` unset): ask the user for the base branch.
- **CLI missing, unauthenticated, or failing**, or **provider without a CLI**: tell the user, then use local `git` with the source and target branches:
  `git fetch origin <source> <target>`, `git log origin/<target>..origin/<source> --oneline`, `git diff origin/<target>...origin/<source>`.
- **Branches unknown or not fetchable**: ask the user to state the source and target branch of the PR/MR, and optionally paste its description or diff.
- **No commits and no changes**: tell the user there is nothing to describe.

## Tone

- Neutral and factual
- Reviewer-friendly: make it easy to understand scope and how to verify
- No marketing speak; no "This amazing PR adds..."

## Anti-Patterns

- ❌ Title that repeats ticket number only ("JIRA-123")
- ❌ Description that is only "See commits"
- ❌ Huge bullet list of every file touched

