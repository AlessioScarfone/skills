---
name: create-agents-md
description: Generate an AGENTS.md file for a repository. Use when user asks to create AGENTS.md files, analyze codebase for AI agent documentation, set up AI-friendly project documentation, or generate context files for AI coding assistants. Triggers on "create AGENTS.md", "generate agents", "analyze codebase for AI", "AI documentation setup", "hierarchical agents".
---

# AGENTS.md Generator

Generate an AGENTS.md structure optimized for AI coding agents with minimal token usage. Follow the public guidance at https://agents.md/.
AGENTS.md is a Markdown file that serves as a "README for agents" - a dedicated, predictable place to provide context and instructions to help AI coding agents work on your project. It complements README.md by containing detailed technical context that coding agents need but might clutter a human-focused README. 
If an AGENTS.md file already exists, update it with new instructions or context. If it doesn't exist, create a new one.

## Core Principles
- **Agent-focused:** Guidance is tailored for AI coding agents
- **Format:** use standard Markdown
- **AGENTS.md is LIGHTWEIGHT:** Only universal guidance, links to sub-files (~100-200 lines max)
- **Standardized location:** Placed at repository root (or subproject roots for monorepos)

## Repository Analysis

Analyze and report:
1. **Repository type**: Monorepo, multi-package, or simple?
2. **Tech stack**: Languages, frameworks, key tools
3. **Major directories**, examples:
   - Apps (`apps/web`, `apps/api`, `apps/mobile`)
   - Services (`services/auth`, `services/transcribe`)
   - Plugin (`plugin/auth`)
   - Packages (`packages/ui`, `packages/shared`)
   - Workers (`workers/queue`, `workers/cron`)
4. **Build system**: pnpm/npm/yarn workspaces? Turborepo? Lerna?
5. **Testing setup**: Jest, Vitest, Playwright, pytest?
6. **Key patterns**: Organization, conventions, examples, anti-patterns, testings

### File Structure

#### Project Overview

- Brief description of what the project does
- Architecture overview if complex
- Key technologies and frameworks used

#### Setup Commands

- Installation instructions
- Environment setup steps
- Dependency management commands
- Database setup if applicable

#### Development Workflow

- How to start development server
- Build commands
- Watch/hot-reload setup
- Package manager specifics (npm, pnpm, yarn, etc.)

#### Testing Instructions

- How to run tests (unit, integration, e2e)
- Test file locations and naming conventions
- Coverage requirements
- Specific test patterns or frameworks used
- How to run subset of tests or focus on specific areas

#### Code Style Guidelines

- Language-specific conventions
- Linting and formatting rules
- File organization patterns
- Naming conventions
- Import/export patterns

#### Build and Deployment

- Build commands and outputs
- Environment configurations
- Deployment steps and requirements
- CI/CD pipeline information

### Optional but Recommended Sections

#### Security Considerations

- Security testing requirements
- Secrets management
- Authentication patterns
- Permission models

#### Monorepo Instructions (if applicable)

- How to work with multiple packages
- Cross-package dependencies
- Selective building/testing
- Package-specific commands

#### Pull Request Guidelines

- Title format requirements
- Required checks before submission
- Review process
- Commit message conventions

#### Debugging and Troubleshooting

- Common issues and solutions
- Logging patterns
- Debug configuration
- Performance considerations


## Output Format

Check template for AGENTS.md in `references/agents-md-template.md`. Use it as a starting point, filling in project-specific details.

## Quality Checklist

Before generating, verify:
- [ ] AGENTS.md exists at root
- [ ] Commands are copy-paste ready
- [ ] No duplication
- [ ] Every "DO" has real file example
- [ ] Every "DON'T" references real anti-pattern

# Best Practices

- Keep AGENTS.md files small and focused
- Use for project-specific conventions
- Be specific: include exact commands
- Prefer **short, concrete references** over long prose:
  - Link to project docs, specs, and runbooks
  - Point to example files or directories (e.g., `see src/api/users.ts for canonical pattern`)
  - Include the most important commands with exact CLI invocations
  - use code blocks to wrap commands and file paths
- Reference existing code examples when possible
- Update as project evolves

## What to Avoid

- General programming advice
- Framework documentation (reference official docs)
- Long examples (reference code files)
- Duplicate information from skills
- Anti-Patterns, omit these
  - "Welcome to..." or "This document explains..."
  - "You should..." or "Remember to..."
  - Obvious instructions ("run tests", "write clean code")
  - Explanations of why (just say what)
  - Long prose paragraphs