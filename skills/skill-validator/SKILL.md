---
name: skill-validator
description: Validates an existing agent skill against the agentskills.io specification. Audits SKILL.md structure, metadata correctness, file hierarchy, instruction tone, and checklist compliance. Produces a pass/fail report with actionable remediation steps. Use when reviewing a skill before publishing, auditing a skill library, or debugging why a skill is not correctly invoked. Don't use for creating new skills, updating README files, or general documentation reviews.
---

# Skill Validation Procedure

Follow these steps to audit an existing skill directory and produce a structured compliance report.

## Step 1: Locate the Target Skill

1. Identify the absolute path to the skill directory to validate (e.g., `/path/to/skills/my-skill`).
2. Confirm the directory exists and contains a `SKILL.md` file. If either is missing, halt and report:
   `FATAL: Target directory not found or SKILL.md is absent.`
4. Report if the skill is global or project-scoped based on its location (e.g., global if under `~/.copilot/skills/`, project-scoped if under `.github/skills/`).
3. Set `SKILL_DIR` to the resolved absolute path for use in subsequent steps.

## Step 2: Read validation rules
1. Load the validation rules and severity definitions from `references/validation-rules.md` into memory for reference during checks.

## Step 3: Extract and Validate Metadata

1. Read the YAML frontmatter block (lines between the first and second `---` delimiters) from `SKILL_DIR/SKILL.md`. Frontmatter absence should be treated as a validation failure, it is included in the metadata checks below.
2. Apply the rules in `references/validation-rules.md` (Section: **Metadata Constraints**) to each item found. Use script if available. If not, apply rules manually.
eg. Execute `python3 scripts/validate-metadata.py --name "[name]" --description "[description]"` to run deterministic metatada checks.
3. For each violation, append a finding with the format: `<Severity> [<CHECK_CODE-XX>]: <description of violation> — SKILL.md`
   eg. `FAIL [META-XX]: <description of violation> — <path>`

## Step 4: Audit File Structure

1. List all files and folders inside `SKILL_DIR`.
2. Apply the rules in `references/validation-rules.md` (Section: **File Structure Rules**) to each item found. Use script if available. If not, apply rules manually.
3. For each violation, append a finding with the format:
   `FAIL [CHECK_CODE-XX]: <description of violation> — <path>`

Key checks to perform:
- Only `scripts/`, `references/`, `assets/`, `templates` subdirectories are allowed.
- No nested subfolders inside those subdirectories (flat hierarchy).
- No human-centric files (`README.md`, `CHANGELOG.md`, `INSTALLATION.md`, etc.) exist in the root.
- All files in `scripts/` are executable scripts (`.py`, `.sh`, `.js`).

## Step 5: Inspect SKILL.md Content

Apply the rules in `references/validation-rules.md` (Section: **SKILL.md Content Rules**) to each item found. Use script if available. If not, apply rules manually.
Execute `python3 scripts/validate-skill.py --path "[SKILL_DIR]/SKILL.md"` to run deterministic content checks.
Capture all `WARN` and `FAIL` lines from `stdout`.

## Step 6: Check Progressive Disclosure

1. Apply the rules in `references/validation-rules.md` (Section: **Progressive Disclosure Rules**) to each item found. Use script if available. If not, apply rules manually.
2. Identify all `references/`, `templates/`, `assets/` files listed in `SKILL_DIR`.
3. For each such file, verify that `SKILL.md` contains at least one explicit instruction directing the agent to read it (e.g., `Read references/foo.md`).
4. Flag orphaned reference files with:
   `WARN [PD-01]: references/[file] exists but is never cited in SKILL.md.`
5. Identify any large inline block (>30 lines of schema, table, or enumeration) inside `SKILL.md` and flag it:
   `WARN [PD-02]: Inline block at line [N] (~[M] lines) should be extracted to references/.`

## Step 7: Produce the Validation Report

Compile all findings into a structured report using the template in `assets/report-template.md`.
Present the report to the user. For each `FAIL` finding, include a one-line **Remediation** hint.

## Error Handling

- If `scripts/validate-metadata.py` is not found, read the metadata constraints directly from `references/validation-rules.md` and evaluate manually.
- If `scripts/validate-skill.py` fails with a Python error, perform the SKILL.md content validation checks manually by reading `SKILL_DIR/SKILL.md` line by line.
- If the skill has no frontmatter (`---` delimiters absent), flag `FAIL [META-01]: No YAML frontmatter found` and skip Step 2 checks.
