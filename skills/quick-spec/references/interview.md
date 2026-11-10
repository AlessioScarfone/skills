# Round-based requirement interview

Resolve every open point **before** writing the spec. The spec is a contract — it must not ship
with unanswered questions inside it.

## The design tree

Model the feature as a **design tree**: every decision branches into the decisions that hang off it.

The **frontier** is every decision whose prerequisites are already settled — the questions that can
be asked *now* without guessing at answers not yet heard.

A question whose answer depends on another question still open in this round belongs to a **later**
round, not this one.

## Fact-finding comes first

Finding *facts* is the agent's job, never the user's. Before round 1:

- Extract everything the user prompt already states (goal, users, behaviors, constraints).
- Dispatch an `Explore` subagent scoped to the feature to collect: stack and test tooling, files
  the feature touches, patterns to follow (with an example file), and test/build/lint commands.
- If a later question needs another codebase fact, dispatch a new `Explore` subagent for it.

Never ask the user for anything that can be looked up.

**Do not block on exploration.** A running exploration is an unsettled prerequisite: only the
questions downstream of it wait for the subagent to report. Ask the rest of the frontier now.

## Round format

Ask the whole frontier in one message. Number each question and give the recommended answer, so
the user can reply "ok to all" in one line. Word each question so "yes" accepts the recommendation.

```markdown
❓ **Q1** — **<question title>**: <question body; may include options A/B/C>

➡️ <recommended answer>

---

❓ **Q2** — **<question title>**: <question body>

➡️ <recommended answer>
```

Then wait for the answers before the next round. Each round reshapes the tree: settled decisions
push the frontier outward. Recompute the frontier and ask the next round.

Conduct the interview in the language the user is writing in.

If an ask-questions tool is available, use it to collect the frontier answers, offering the
recommended answer as the default option.

### Round 1 seed

Seed the root of the tree with these topics, dropping any already answered by the prompt or by
fact-finding:

- What the feature does — the desired behavior in 2–3 sentences.
- Who the user is — who benefits from it.
- Functional requirements — the observable behaviors, and how they group into components.
- Cross-cutting constraints — security, performance, data privacy, accessibility.
- Technical notes — implementation hints, API details, architectural considerations.
- Codebase ambiguities — only when exploration found several plausible places or patterns.

These are a starting point, not a fixed questionnaire. Later rounds follow from what the answers
open up.

## When to stop

Stop when the frontier is empty: every branch visited, nothing silently assumed.

Stop escalating when a new round would only produce cosmetic detail, non-testable preferences, or
choices that are cheap to reverse later. Depth belongs where a wrong answer would force a rewrite.

Then show a **decision summary** — one line per settled decision — and ask the user to confirm a
shared understanding has been reached. Only after that confirmation, write the spec.

## Handling non-answers

- **"You decide" / no answer to a specific question** → adopt the recommended answer, state it, and
  carry it into the spec. It is a settled decision, not an open question.
- **User abandons the interview** → adopt the recommended answers for the entire remaining
  frontier, list them explicitly, and write a complete spec. Never leave template placeholders in
  `components` or `constraints`.
- **Contradictory answers across rounds** → surface the contradiction and re-ask that single
  question before moving the frontier.

## Where each answer lands

Every settled decision and every gathered fact must be traceable to a field in the spec. There is
no separate log — the spec itself is the record.

| Kind of information | Destination in the spec |
|---|---|
| Problem statement and motivation from the prompt | `context.summary` |
| Languages, frameworks, test tooling | `context.stack` |
| Existing files the feature touches or mirrors | `context.relevant_code` |
| Patterns to follow | `context.conventions` |
| Test / build / lint commands | `context.commands` |
| Observable, testable behavior | `components.<GROUP>.requirements.<N>` |
| Non-functional constraint (security, performance, privacy, a11y) | `constraints.<GROUP>.requirements.<N>` |
| Something explicitly out of scope | `non_goals` |
| Technical choice, architecture, or rationale | `technical_notes` |
| Other interview decision that shapes implementation | `context.decisions` |
| Dependency outside the project | `feature.prerequisites` |
| Confirmed deferral on an external blocker | `open_questions` (exception — see below) |

## Deferral rule

`open_questions` is an escape hatch, not a parking lot. Write an entry **only** when both hold:

1. The answer depends on a party or fact outside this session — a third-party decision, a contract
   not yet signed, data that does not exist yet. Uncertainty on the user's part is not a blocker;
   put the question to them and settle it.
2. The user has **explicitly confirmed** the deferral after the question was asked.

Each deferred entry records `blocked_by` and the ACID it `affects`. In the normal case the section
is omitted entirely.
