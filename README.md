# Agent Skills

Skills for AI-assisted - [Agent Skills Documentation](https://agentskills.io)


## Available Skills

 Skill | Description |
|-------|-------------|
| `code-review` | Reviews local changes or diffs for bugs, security vulnerabilities, and code quality issues, reporting only verified, high-impact findings with confidence scoring. |
| `create-agents-md` | Generate an AGENTS.md file for a repository |
| `create-ux-prototype` | Facilitate UX design sessions with structured brainstorming, design decision workshops, UX specification writing, and standalone HTML/CSS prototyping |
| `skill-creator` | Authors and structures professional-grade agent skills following the agentskills.io spec. Use when creating new skill directories, drafting procedural instructions, or optimizing metadata for discoverability. Don't use for general documentation, non-agentic library code, or README files. |
| `pr-description`| Generate pull/merge request titles and descriptions from diffs and context. Use when creating a PR, writing PR description, drafting merge request, or summarizing changes for review. |
| `skill-validator` | Validates an existing agent skill against the agentskills.io specification. Audits SKILL.md structure, metadata, file hierarchy, instruction tone, and checklist compliance, producing a pass/fail report with remediation steps. |
| `show-me` | Helps the user understand the current topic visually with concise diagrams, code-shape sketches, and focused HTML artifacts. |
| `quick-spec` | Creates a standalone, one-shot feature spec (`<spec-name>.spec.yaml`) through codebase analysis and a round-based interview, embedding the gathered context in the spec itself — no project context file or hooks required. |
| `quick-plan` | Generates a self-contained, requirement-tagged implementation plan (`<spec-name>.plan.md`) from a `quick-spec` spec, ready to hand to a coding agent. |


## Other skills
- [ponytail](https://github.com/dietrichgebert/ponytail)
- [diagram-design](https://github.com/cathrynlavery/diagram-design)
- [mattpocock skills](https://github.com/mattpocock/skills)
- [skills-best-practices](https://github.com/mgechev/skills-best-practices) -> "skill-creator"
