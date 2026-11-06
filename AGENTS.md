# AGENTS.md

## Project Overview

Collection of agent skills following the [agentskills.io](https://agentskills.io) spec. No build, package manager, or CI.

```
skills/<skill-name>/
  SKILL.md        # required: YAML frontmatter + procedure
  assets/         # output templates loaded on demand
  references/     # extra context loaded on demand (one level deep)
  scripts/        # small deterministic CLI helpers
```

Only create the subdirectories a skill actually uses.

## Skill Authoring Rules

- Frontmatter `name`: 1–64 chars, `^[a-z0-9]+(-[a-z0-9]+)*$`, equal to the directory name.
- Frontmatter `description`: ≤1024 chars, third person, no `I/we/you/your`. State what it does + "Use when …" + "Don't use for …" (see `skills/skill-creator/SKILL.md`).
- Optional frontmatter keys in use: `argument-hint` (`skills/code-review/SKILL.md`), `disable-model-invocation` (`skills/create-ux-prototype/SKILL.md`), `metadata.credits` (`skills/pr-description/SKILL.md`).
- `SKILL.md` must stay under 500 lines; move large templates or rule sets into `assets/` or `references/`.
- Write steps in imperative mood ("Read…", "Run…"); include a `## Error Handling` section.
- Reference bundled files with relative forward-slash paths and tell the agent when to load them, e.g. "Read `references/content-guidelines.md` before writing…" (`skills/pr-description/SKILL.md`).
- Canonical structure: `skills/skill-creator/assets/skill-template.md`; checklist: `skills/skill-creator/references/checklist.md`.

## Code Style

- Markdown: ATX headings, fenced code blocks with language tags, no long prose.
- Python scripts: stdlib only, `argparse` CLI, print `SUCCESS`/`FAIL`/`WARN` lines, non-zero exit on failure (see `skills/skill-validator/scripts/validate-skill.py`).
- `skills/skill-creator/scripts/validate-metadata.py` and `skills/skill-validator/scripts/validate-metadata.py` are identical copies — change both together.

## Adding or Changing a Skill

1. Create or edit `skills/<skill-name>/`.
2. Run both validators above for that skill.
3. Update the "Available Skills" table in `README.md` (name + short description).

## Commit Guidelines

- Conventional Commits: `feat:`, `fix:`, `docs:` with a lowercase summary, e.g. `feat: add skill-validator for auditing agent skills against specification`.
- One skill per commit when possible.
