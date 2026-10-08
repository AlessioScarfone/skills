#!/usr/bin/env python3
"""
validate-skill.py — Deterministic content linter for SKILL.md files.

Usage:
    python3 scripts/validate-skill.py --path <path-to-SKILL.md>

Exit codes:
    0 — No FAIL findings (warnings may exist)
    1 — At least one FAIL finding
"""

import re
import sys
import argparse
from pathlib import Path

MAX_LINES = 500
LARGE_INLINE_BLOCK_THRESHOLD = 30

IMPERATIVE_VIOLATIONS = re.compile(r"^\s*(I |We |You )", re.MULTILINE)
BACKSLASH_PATH = re.compile(r"[\w\-]+\\[\w\-\\]+")
FRONTMATTER_DELIMITER = "---"


def check_line_count(lines: list[str]) -> list[str]:
    findings = []
    count = len(lines)
    if count >= MAX_LINES:
        findings.append(
            f"FAIL [CONTENT-01]: SKILL.md has {count} lines. Must be under {MAX_LINES}."
        )
    return findings


def check_imperative_mood(content: str) -> list[str]:
    findings = []
    for match in IMPERATIVE_VIOLATIONS.finditer(content):
        line_no = content[: match.start()].count("\n") + 1
        findings.append(
            f"WARN [CONTENT-02]: First/second-person pronoun at line {line_no}. "
            "Rewrite in third-person imperative (e.g., 'Extract the value')."
        )
    return findings


def check_error_handling_section(content: str) -> list[str]:
    if "## Error Handling" not in content and "## error handling" not in content.lower():
        return ["WARN [CONTENT-03]: No '## Error Handling' section found in SKILL.md."]
    return []


def check_backslash_paths(content: str, lines: list[str]) -> list[str]:
    findings = []
    for i, line in enumerate(lines, start=1):
        if BACKSLASH_PATH.search(line):
            findings.append(
                f"FAIL [CONTENT-04]: Backslash path detected at line {i}. "
                "Use forward slashes for all file paths."
            )
    return findings


def check_large_inline_blocks(lines: list[str]) -> list[str]:
    """Flag contiguous non-heading, non-blank blocks exceeding the threshold."""
    findings = []
    block_start = None
    block_length = 0

    for i, line in enumerate(lines, start=1):
        stripped = line.strip()
        is_structural = stripped.startswith("#") or stripped == ""
        if not is_structural:
            if block_start is None:
                block_start = i
            block_length += 1
        else:
            if block_length > LARGE_INLINE_BLOCK_THRESHOLD:
                findings.append(
                    f"WARN [CONTENT-05]: Large inline block starting at line {block_start} "
                    f"({block_length} lines). Consider extracting to references/ or assets/."
                )
            block_start = None
            block_length = 0

    # Catch block at end of file
    if block_length > LARGE_INLINE_BLOCK_THRESHOLD:
        findings.append(
            f"WARN [CONTENT-05]: Large inline block starting at line {block_start} "
            f"({block_length} lines). Consider extracting to references/ or assets/."
        )

    return findings


def strip_frontmatter(content: str) -> tuple[str, list[str]]:
    """Return content without YAML frontmatter and the raw lines."""
    lines = content.splitlines()
    if not lines or lines[0].strip() != FRONTMATTER_DELIMITER:
        return content, lines

    for i in range(1, len(lines)):
        if lines[i].strip() == FRONTMATTER_DELIMITER:
            body_lines = lines[i + 1 :]
            return "\n".join(body_lines), body_lines

    return content, lines


def main():
    parser = argparse.ArgumentParser(description="Lint a SKILL.md file for content compliance.")
    parser.add_argument("--path", required=True, help="Absolute or relative path to SKILL.md")
    args = parser.parse_args()

    skill_path = Path(args.path)
    if not skill_path.exists():
        print(f"FATAL: File not found: {skill_path}", file=sys.stderr)
        sys.exit(1)

    raw_content = skill_path.read_text(encoding="utf-8")
    body, body_lines = strip_frontmatter(raw_content)

    findings: list[str] = []
    findings += check_line_count(body_lines)
    findings += check_imperative_mood(body)
    findings += check_error_handling_section(body)
    findings += check_backslash_paths(body, body_lines)
    findings += check_large_inline_blocks(body_lines)

    if findings:
        for f in findings:
            print(f)
        has_fail = any(f.startswith("FAIL") for f in findings)
        sys.exit(1 if has_fail else 0)
    else:
        print("SUCCESS: SKILL.md passes all content checks.")
        sys.exit(0)


if __name__ == "__main__":
    main()
