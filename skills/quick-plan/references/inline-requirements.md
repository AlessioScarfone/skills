# Inline Requirements

Used only in inline mode (no spec file). The requirements go in the plan's frontmatter under `requirements`; see `assets/plan-inline.template.md` for the exact shape.

## Rules

- `summary`: 1–3 sentences, the problem and the intended outcome, in the user's words.
- One group key per area of behavior, UPPER_SNAKE (e.g. `LEAD`, `EXPORT`). Cross-cutting needs (performance, security) get their own group. Group keys are unique.
- Each requirement is `id` (string, `'1'`, `'2'`, …) plus `text`: one observable, pass/fail behavior. Split a requirement whose text contains "and" between two behaviors.
- Requirement tags in tasks are `<GROUP_KEY>.<id>`, e.g. `LEAD.2`.
- `non_goals`: only scope exclusions stated by the user or clearly implied. Omit the key if there are none.
- Keep it short: this is a lightweight contract, not a full spec. Aim for 2–8 requirements.
- Do not add `open_questions`. Ask the user, or adopt the recommended answer and record it in **Strategy**.
- Requirements describe behavior, not implementation. Implementation choices belong in **Strategy** and the tasks.

## Escalate to quick-spec

Suggest `/quick-spec` instead of planning inline when the feature has many components, external blockers, or needs a long interview. Mention it once, then continue inline if the user declines.
