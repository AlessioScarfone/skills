---
name: quick-plan
description: Generates a self-contained implementation plan (`<spec-name>.plan.md`) from a standalone spec created by quick-spec, breaking its requirements into an ordered, testable task checklist that a coding agent can execute directly. Embeds the spec context, execution instructions, requirement-tagged tasks, and verification checkpoints. Use when the user wants to plan a feature from a `*.spec.yaml`, generate implementation tasks, or regenerate a plan after the spec changed. Don't use for writing or changing the spec (use quick-spec) or implementing code.
argument-hint: '[path/to/<spec-name>.spec.yaml]'
disable-model-invocation: true
---

# Quick Plan

Turns a `<spec-name>.spec.yaml` into `<spec-name>.plan.md`, written next to the spec. The plan is the hand-off to an implementing agent: it must be executable without further context. This skill never modifies the spec.

## Procedures

**Step 1: Select the spec**
1. If a spec path is provided, use it.
2. Otherwise, list `*.spec.yaml` files in the current working directory:
   - Exactly one → use it.
   - More than one → show each `feature.name` and `description` and ask which one to plan.
   - None → stop and tell the user to run `/quick-spec` first.
3. Output `Selected spec: <path>`.

**Step 2: Read the spec**
1. Read the whole spec: `feature`, `context`, `components`, `constraints`, `non_goals`, `technical_notes`, `open_questions`.
2. If `components` is empty or still contains template placeholders, stop and tell the user to complete it with `/quick-spec`.
3. If `open_questions` exist, list them and ask whether each blocker has lifted:
   - Lifted → tell the user to fold the answer into the spec with `/quick-spec` first.
   - Still blocked → plan around it and mark the affected tasks as blocked in the plan.

**Step 3: Break the spec into tasks**
1. Read `references/task-rules.md` and follow it.
2. Open files from `context.relevant_code` only when a task needs a precise location or pattern; do not re-run a full codebase analysis.
3. Tag every task with the requirement ID(s) it satisfies, e.g. `_(LOGIN.1)_`. Cover every requirement in `components` and `constraints` at least once.
4. Build checkpoints from `context.commands`; never invent commands.

**Step 4: Write the plan**
1. Read `assets/plan.template.md` and fill every section:
   - Frontmatter: `spec-name`, `spec-file` (spec path relative to the plan), `created` = today.
   - **Agent Instructions**: keep as-is, replacing `[spec-file]`.
   - **Context**: condensed excerpt of `context` and `non_goals`.
   - **Strategy**, **Task List**: from Step 3.
2. Drop placeholder lines that have no source (e.g. a missing lint command).
3. Write `<spec-folder>/<spec-name>.plan.md`. If it already exists, overwrite it without asking.
4. Confirm:
   > ✅ Created `<path>/<spec-name>.plan.md` with N tasks. _(Add "— replaced the previous plan" when overwritten.)_
   > 📋 Tasks:
   > 1. \<task 1\>
   > 2. \<task 2\>
   > Hand the plan to a coding agent, e.g. "Implement `<path>/<spec-name>.plan.md`".

## Output Rules

- Resolve `assets/` and `references/` paths relative to this SKILL.md, not the user's workspace.
- One plan per spec, in the same folder as the spec.
- Coding tasks only — no deployment, documentation, or manual testing tasks.
- Keep tasks small (S/M) and ordered so dependencies are satisfied bottom-up.
- Never modify the spec file.

## Error Handling

- If the given spec path does not exist, list `*.spec.yaml` files in its folder and ask the user to choose.
- If the spec is not valid YAML or lacks the `feature` key, report the problem and tell the user to fix it with `/quick-spec`.
- If the spec has no `context`, plan from the requirements alone and state in the **Context** section that codebase context is missing.
- If a requirement cannot be mapped to any task, stop and report the requirement ID instead of writing an incomplete plan.
