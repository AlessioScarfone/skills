<!--
Inline mode only. Use this frontmatter and this first Agent Instructions bullet
in place of the `spec-file` frontmatter and the `[spec-file]` bullet of
plan.template.md. Everything else in plan.template.md stays the same.
Group keys are UPPER_SNAKE and unique; ids are strings, unique within a group.
-->

## Frontmatter

```yaml
---
spec-name: spec-name
created: YYYY-MM-DD
requirements:
  summary: >-
    1-3 sentences: the problem and the intended outcome.
  GROUP_KEY:                          # e.g. LOGIN, EXPORT, PERF
    - id: '1'
      text: Observable, testable behavior.
    - id: '2'
      text: Another observable, testable behavior.
  non_goals:
    - What is explicitly out of scope.
---
```

## First Agent Instructions bullet

```markdown
- The contract is the `requirements` block in this file's frontmatter. Read it before starting.
```
