---
name: quick-spec
description: Creates or updates a standalone, one-shot feature spec (`<spec-name>.spec.yaml`) with testable requirements, without any project-level context file or hooks. Gathers context from the user prompt, a scoped codebase analysis, and a round-based interview, and embeds it in the spec under a `context` key. Use when the user wants to spec a feature, capture requirements, or draft a spec in a repository that has no spec framework configured. Don't use for generating the implementation plan (use quick-plan), implementing code, or projects already managed with barespec (use spec-create).
argument-hint: <feature description> [output folder]
disable-model-invocation: true
---

# Quick Spec

Produces a single self-contained `<spec-name>.spec.yaml` — the contract between user intent and implementation. All context lives inside the file; no `context.md`, config, or hooks are read.

## Procedures

**Step 1: Resolve the target**
1. Read the feature description from the input. If none is provided, ask: _"What feature or requirement should be specced?"_ and wait.
2. Resolve the output folder: the folder given by the user, otherwise the current working directory.
3. Derive a dash-case **spec name** from the description (e.g. `csv-export`, `dark-mode-toggle`).
4. Look for `<output-folder>/<spec-name>.spec.yaml` and scan other `*.spec.yaml` files in the output folder for similar content.
   - If a match exists, show its `feature.name` and `description` and ask whether to **update** it or **create a new spec** with a different name. On update, go to **Step 5**.
   - Otherwise output `📝 Spec name: <spec-name>` and continue.

**Step 2: Gather the facts**
1. Dispatch an `Explore` subagent scoped to the feature. Request: stack and test tooling, files the feature touches, patterns to follow with an example file, and the test/build/lint commands defined in the repository.
2. If the repository is empty or unrelated to the feature (greenfield), skip the codebase facts; context comes only from the prompt and the interview.
3. Do not block on the subagent: ask the frontier questions that do not depend on its findings.

**Step 3: Run the interview**
1. Read `references/interview.md` and follow it to interview the user in rounds until the frontier is empty.
2. Close with a decision summary and wait for explicit confirmation of a shared understanding.
3. Do not write the spec while the frontier is non-empty.

**Step 4: Write the spec**
1. Read `assets/spec.template.yaml` and fill it, following the rules in its header comments.
2. Fill `feature`: `name` = `<spec-name>`, `description` = 2–3 sentences including who the user is, optional `prerequisites`, `created` = today (`YYYY-MM-DD`).
3. Fill `context` from the prompt, the subagent findings, and the interview. Keep it scoped to this feature. Omit empty sub-keys; never invent paths or commands that were not observed.
4. Group functional requirements into `components` with unique `UPPER_SNAKE` keys. Number requirements `1`, `2`, …; use `<N>-<M>` for sub-requirements (max one level, never `-0`). The ACID is `<spec-name>.<GROUP_KEY>.<ID>`.
5. Put cross-cutting requirements under `constraints`; omit the section when there are none.
6. Map every settled decision to its field using the table in `references/interview.md`.
7. Omit `open_questions` unless the user explicitly confirmed a deferral on an external blocker.
8. Remove all template comments and placeholders, then write `<output-folder>/<spec-name>.spec.yaml`.
9. Confirm:
   > ✅ Created `<path>/<spec-name>.spec.yaml`.
   > Next: run `/quick-plan <path>/<spec-name>.spec.yaml` to generate the implementation plan.

**Step 5: Update an existing spec**
1. Read the existing spec and ask what needs to change (new requirements, changed constraints, scope change).
2. Refresh `context` with a scoped `Explore` subagent only when the change touches code not yet covered.
3. Run the interview from `references/interview.md` scoped to the delta: reopen only the branches the change touches and never re-ask what the spec already settles. The same confirmation gate applies.
4. Apply the changes. Append new requirement numbers (or `<N>-<M>` sub-requirements) so existing ACIDs stay stable; never renumber.
5. Drop any `open_questions` entry the update resolved; delete the section when empty.
6. Show a summary of what changed and confirm:
   > ✅ Updated `<path>/<spec-name>.spec.yaml`.
   > The spec changed — run `/quick-plan <path>/<spec-name>.spec.yaml` to regenerate the plan.

## Output Rules

- Resolve `assets/` and `references/` paths relative to this SKILL.md, not the user's workspace.
- One feature per spec file. Do not generate the plan here.
- Express requirements as observable, testable (pass/fail) behaviors; be descriptive, not prescriptive.
- Keep the spec concise: an agent must be able to turn it into a plan without ambiguity.
- A written spec contains no unanswered questions and no template placeholders.

## Error Handling

- If no input is provided, ask for the feature description before doing anything else.
- If the derived name collides with an unrelated spec, show both and ask the user to confirm or pick a different name.
- If the output folder does not exist, create it before writing.
- If the `Explore` subagent is unavailable, gather the codebase facts directly with search and read tools.
- If the user abandons the interview, adopt the recommended answer for every remaining frontier question, list them explicitly, and write a complete spec.
- If the user defers a question, accept it only when the answer depends on a party or fact outside the session and the user confirms; record it in `open_questions` with `blocked_by` and the affected ACID.
