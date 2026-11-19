---
name: quick-plan
description: Generates a self-contained implementation plan (`<name>.plan.md`) that breaks requirements into an ordered, testable task checklist a coding agent can execute directly. Works in two modes - from a standalone `*.spec.yaml` created by quick-spec, or standalone with the requirements defined inline in the plan's frontmatter when no spec is given or present. Embeds the context, execution instructions, requirement-tagged tasks, and verification checkpoints. Use when the user wants to plan a feature from a spec, plan directly from a description without a spec, generate implementation tasks, or regenerate a plan. Don't use for writing or changing a spec file (use quick-spec) or implementing code.
argument-hint: '[path/to/<spec-name>.spec.yaml | feature description]'
disable-model-invocation: true
---

# Quick Plan

Produces `<name>.plan.md`, the hand-off to an implementing agent: it must be executable without further context. Two modes:

- **Spec-file mode**: the contract is a `<spec-name>.spec.yaml`; the plan is written next to it and never modifies it.
- **Inline mode**: no spec file; the contract is a `requirements` block in the plan's own frontmatter.

## Procedures

**Step 1: Select the mode and the source**
1. Spec-file mode when the argument is a path to a spec, or the user asks to plan from a spec.
2. Inline mode when the user passes a feature description instead of a path, asks for a plan without a spec, or an existing `<name>.plan.md` has no `spec-file` key (regenerate it inline).
3. With no argument, list `*.spec.yaml` files in the current working directory:
   - Exactly one → use it (spec-file mode).
   - More than one → show each `feature.name` and `description` and ask which one to plan, offering "no spec, plan inline" as an option.
   - None → inline mode, using the conversation and the user's request as the source. If there is nothing to plan from, ask the user to describe the feature.
4. Output `Mode: spec-file (<path>)` or `Mode: inline`.

**Step 2: Read or define the requirements**

Spec-file mode:
1. Read the whole spec: `feature`, `context`, `components`, `constraints`, `non_goals`, `technical_notes`, `open_questions`.
2. If `components` is empty or still contains template placeholders, stop and tell the user to complete it with `/quick-spec`.
3. If `open_questions` exist, list them and ask whether each blocker has lifted:
   - Lifted → tell the user to fold the answer into the spec with `/quick-spec` first.
   - Still blocked → plan around it and mark the affected tasks as blocked in the plan.

Inline mode:
1. If an existing inline plan is being regenerated, reuse its `requirements` block unless the user changed the request.
2. Otherwise derive requirements from the user's request and the conversation. Read `references/inline-requirements.md` and follow it.
3. Gather context yourself: stack, relevant files, conventions, and test/build/lint commands from a scoped look at the codebase. Never ask the user for anything that can be looked up.
4. Ask at most one round of numbered questions, each with a recommended answer, and only for decisions that would change the tasks. Otherwise adopt the recommended answer and state it in **Strategy**.

**Step 3: Break the requirements into tasks**
1. Read `references/task-rules.md` and follow it.
2. Open files from the context (`context.relevant_code` in spec-file mode, the files you found in inline mode) only when a task needs a precise location or pattern; do not re-run a full codebase analysis.
3. Tag every task with the requirement ID(s) it satisfies, e.g. `_(LOGIN.1)_`. Cover every requirement (spec `components` and `constraints`, or every inline group) at least once.
4. Build checkpoints from the known commands (`context.commands` or the ones found in the repo); never invent commands.

**Step 4: Write the plan**
1. Read `assets/plan.template.md`. In inline mode also read `assets/plan-inline.template.md`. Fill every section:
   - Frontmatter: spec-file mode → `spec-name`, `spec-file` (spec path relative to the plan), `created` = today. Inline mode → `spec-name`, `created`, and the `requirements` block from Step 2; no `spec-file`.
   - **Agent Instructions**: keep as-is. Spec-file mode replaces `[spec-file]`; inline mode uses the inline first bullet.
   - **Context**: condensed excerpt of the spec's `context` and `non_goals`, or the context gathered in Step 2.
   - **Strategy**, **Task List**: from Step 3.
2. Drop placeholder lines that have no source (e.g. a missing lint command).
3. Write the file:
   - Spec-file mode → `<spec-folder>/<spec-name>.plan.md`.
   - Inline mode → `<cwd>/<plan-name>.plan.md`, where `<plan-name>` is a short kebab-case name of the feature (`^[a-z0-9]+(-[a-z0-9]+)*$`), or the user's requested path.
   - If the file already exists, overwrite it without asking.
4. Confirm:
   > ✅ Created `<path>/<name>.plan.md` with N tasks. _(Add "— replaced the previous plan" when overwritten.)_
   > 📋 Tasks:
   > 1. \<task 1\>
   > 2. \<task 2\>
   > Hand the plan to a coding agent, e.g. "Implement `<path>/<name>.plan.md`".
   In inline mode add: "Requirements live in the plan's frontmatter; edit them there and re-run `/quick-plan <path>` to regenerate the tasks."

## Output Rules

- Resolve `assets/` and `references/` paths relative to this SKILL.md, not the user's workspace.
- One plan per feature. Spec-file mode writes it in the same folder as the spec.
- In inline mode the plan frontmatter is the only contract: no `spec-file` key, and no separate spec file is created.
- Coding tasks only — no deployment, documentation, or manual testing tasks.
- Keep tasks small (S/M) and ordered so dependencies are satisfied bottom-up.
- Never modify a spec file.

## Error Handling

- If the given spec path does not exist, list `*.spec.yaml` files in its folder and ask the user to choose or to plan inline.
- If the spec is not valid YAML or lacks the `feature` key, report the problem and tell the user to fix it with `/quick-spec`.
- If the spec has no `context`, plan from the requirements alone and state in the **Context** section that codebase context is missing.
- If a requirement cannot be mapped to any task, stop and report the requirement ID instead of writing an incomplete plan.
- In inline mode, if the request is too vague to yield at least one testable requirement, ask the user to clarify instead of inventing requirements.
