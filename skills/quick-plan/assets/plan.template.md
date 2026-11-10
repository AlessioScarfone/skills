---
spec-name: spec-name
spec-file: ./spec-name.spec.yaml
created: YYYY-MM-DD
---

# Implementation Plan: [Feature Name]

## Agent Instructions

- The contract is `[spec-file]`. Read it before starting; if this plan and the spec disagree, the spec wins.
- Execute tasks in order. Do not skip ahead: later tasks depend on earlier ones.
- Mark each task `- [x]` as soon as it is done. Mark a group header done only when all its sub-tasks are done.
- At every checkpoint, run the listed commands. Do not continue until they pass; fix the failure first.
- Tasks marked `- [ ]*` are optional: implement them only after all required tasks are done.
- Stay in scope: implement only what the tagged requirements describe. Respect the non-goals.
- If a task is blocked or ambiguous, stop and ask instead of guessing.

## Context

- **Goal**: [1–2 sentences from `context.summary`]
- **Stack**: [from `context.stack`]
- **Relevant code**:
  - `path/to/file.ts` — [role]
- **Conventions**:
  - [Pattern (see `path/to/example.ts`)]
- **Non-goals**:
  - [from `non_goals`]

## Strategy

[2–5 sentences describing the technical strategy. Be specific: name the files, patterns, and mechanisms. Not "add an endpoint" but "add a POST /api/x handler in src/api/x.ts following the pattern in src/api/y.ts". If a key file or location is unknown, say so explicitly.]

**Acceptance criteria:**
- [Specific, testable condition mapped to a requirement ID, e.g. THEME.1]

**Verification:**
- Tests: `[context.commands.test]`
- Build: `[context.commands.build]`
- Lint: `[context.commands.lint]`

**Estimated scope:** [Small: 1-2 files | Medium: 3-5 files | Large: 5+ files]

## Task List

### 1. [Group name]
- [ ] 1.1 [Task objective] _(THEME.1)_
  - [Implementation detail]
- [ ] 1.2 ...
- [ ] 1.3 Checkpoint: `[test command]` passes

### 2. [Group name]
- [ ]* 2.1 [Optional task] _(THEME.2)_
- [ ] 2.2 ...
- [ ] 2.3 Checkpoint: `[test command]` and `[build command]` pass

### Checkpoint: Complete
- [ ] All tests pass
- [ ] Build succeeds
- [ ] Lint passes
