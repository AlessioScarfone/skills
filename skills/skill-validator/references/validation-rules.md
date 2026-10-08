# Validation Rules Reference

This file defines the exact constraints enforced during skill validation. Read this file when scripts are unavailable or when manually auditing a skill.

## Metadata Constraints

| Field         | Rule                                                                                      | Check Code  | Validated by                        | Details |
|---------------|-------------------------------------------------------------------------------------------|-------------|-------------------------------------|---------|
| Frontmatter   | SKILL.md must contain YAML frontmatter with opening and closing `---` delimiters          | META-00     | Model (manual check)                | |
| `name`        | The `name` field must be present and non-empty in the frontmatter                         | META-00.1   | Model (manual check)                | |
| `description` | The `description` field must be present and non-empty in the frontmatter                  | META-00.2   | Model (manual check)                | |
| `name`        | 1–64 characters, lowercase letters, digits, and single hyphens only                      | META-01     | `scripts/validate-metadata.py`       | |
| `name`        | Cannot start or end with a hyphen; no consecutive hyphens                                 | META-02     | `scripts/validate-metadata.py`      | |
| `name`        | Must exactly match the parent directory name                                              | META-03     | Model (manual check)                | Verify the `name` field equals the base name of `SKILL_DIR`|
| `description` | Maximum 1,024 characters                                                                  | META-04     | `scripts/validate-metadata.py`      | |
| `description` | Must not contain: "I", "me", "my", "we", "our", "you", "your" (case-insensitive, whole word) | META-05 | `scripts/validate-metadata.py`       | |
| `description` | Must include at least one positive trigger ("Use when…")                                  | META-06     | Model (manual check)                | |
| `description` | Must include at least one negative trigger ("Don't use for…" or "Do not use for…")       | META-07     | Model (manual check)                 | |

## File Structure Rules

| Rule                                                                 | Check Code | Validated by         |
|----------------------------------------------------------------------|------------|----------------------|
| Only `scripts/`, `references/`, and `assets/` subdirs are permitted | FS-01      | Model (manual check) |
| Subdirectories must be flat (no nested subfolders)                   | FS-02      | Model (manual check) |
| `README.md`, `CHANGELOG.md`, `INSTALLATION.md` must not exist       | FS-03      | Model (manual check) |
| Files in `scripts/` must be executable scripts (`.py`, `.sh`, `.js`)| FS-04      | Model (manual check) |
| `SKILL.md` must be present in the root of the skill directory        | FS-05      | Model (manual check) |

## SKILL.md Content Rules

| Rule                                                                        | Check Code   | Validated by                    |
|-----------------------------------------------------------------------------|--------------|----------------------------------|
| File body (excluding frontmatter) must be under 500 lines                   | CONTENT-01   | `scripts/validate-skill.py`     |
| Instructions must not start with first/second-person pronouns               | CONTENT-02   | `scripts/validate-skill.py`     |
| An `## Error Handling` section must be present                              | CONTENT-03   | `scripts/validate-skill.py`     |
| File paths must use forward slashes (`/`) only                              | CONTENT-04   | `scripts/validate-skill.py`     |
| Inline blocks >30 consecutive non-heading lines should be in `references/`  | CONTENT-05   | `scripts/validate-skill.py`     |

## Progressive Disclosure Rules

| Rule                                                                                  | Check Code | Validated by         |
|---------------------------------------------------------------------------------------|------------|----------------------|
| Every file in `references/`, `templates/`, `assets/`, `scripts/` must be cited in `SKILL.md`                | PD-01      | Model (manual check) |
| Large inline data blobs (>30 lines) should be extracted to `references/` or `assets/`| PD-02      | Model (manual check) |

## Severity Definitions

- **PASS ✅** — Meets the requirement. No action needed.
- **FAIL 🚫** — Blocks publication. Must be fixed before the skill is deployed.
- **WARN ⚠️** — Quality issue. Should be addressed but does not block publication.
- **FATAL ❌** — Validation cannot proceed (e.g., file not found, missing frontmatter).


##  Script Execution Examples

```
python3 scripts/validate-metadata.py --name "[name]" --description "[description]"
```

```
python3 scripts/validate-skill.py --path "[SKILL_DIR]/SKILL.md"
```

Record the outcome:
   - **PASS** — script exits with code 0.
   - **FAIL** — capture `stderr` output verbatim; it contains the specific error category (e.g., `NAME ERROR`, `STYLE WARNING`).