---
name: create-ux-prototype
description: Facilitate UX design sessions with structured brainstorming, design decision workshops, UX specification writing, and standalone HTML/CSS prototyping. Use when user asks to design a UI, create a UX prototype, brainstorm design decisions, review a design, build an HTML mockup, create a wireframe, or mentions "UX", "prototype", "wireframe", "design decisions", "UI design", "mockup".
disable-model-invocation: true
---

# Create UX

## Quick Start

1. Read user request to identify which workflow applies
2. Read only the section of [references/workflows.md](references/workflows.md) that matches the chosen workflow
3. Read the templates only when the workflow reaches that output (see "HTML Prototype Rules" and "UX Specification Format")
4. Follow the C/R/A protocol after every generated section

## Workflows

### [1] New Design Project

Full guided journey — 7 sequential sections:

1. **Project Vision** — goals, users, platform, constraints
2. **Design Decisions Workshop** — resolve 4-6 key choices before building
3. **Component Inventory** — list reusable UI building blocks (8-15 components)
4. **Key Screen Wireframes** — ASCII wireframes for 2-3 critical screens
5. **Prototype Specification** — scope, design tokens, interactions
6. **HTML/CSS Prototype** — complete standalone HTML file
7. **Completion** — summary and save instructions

### [2] Brainstorm Decisions

Focused workshop on specific design choices. Present 2-4 options per decision with pros/cons and recommendation. No full project required.

### [3] Create HTML Prototype

Quick prototype with lighter upfront questions. Minimum input: what it is, who uses it, key screens/interactions, style preferences.

### [4] Review & Refine

Iterate on existing spec or prototype. Identify 3-5 improvement areas, work through one at a time.

See [references/workflows.md](references/workflows.md) for the detailed step-by-step process for each workflow.

## Collaboration Protocol (C/R/A)

After **every** generated section, present:

```
What would you like to do?
[C] Continue    — Accept and move to next section
[R] Refine      — Give feedback, I'll rework it
[A] Alternative — Show a completely different approach
```

- **C** → finalize section, advance to next
- **R** → ask what to change, rework, re-present C/R/A
- **A** → generate significantly different version, re-present C/R/A
- Never advance without explicit **C**

## HTML Prototype Rules

- Single self-contained `.html` file — no external dependencies
- Semantic HTML5 (`<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`)
- CSS custom properties at `:root` for design tokens
- Responsive with `@media` breakpoints (desktop 1200px, tablet 768px, mobile 375px)
- Flexbox/Grid layout — no floats
- ARIA labels on interactive elements
- Vanilla JS only — no frameworks, comment every function
- Realistic placeholder content — no "Lorem ipsum" for UI labels
- Read [assets/prototype-template.html](assets/prototype-template.html) before generating the prototype and use it as the structural base

## UX Specification Format

Read [assets/spec-template.md](assets/spec-template.md) and output as Markdown following it. Include:

- YAML frontmatter (project, date, sections_completed, status)
- `##` heading per section
- Tables for decisions log, component inventory, prototype spec
- ASCII wireframes for key screens

## Hard Rules

1. **Never generate output without asking questions first** — at minimum confirm what you're building
2. **Never auto-advance** past a section without explicit [C]
3. **Never generate a prototype** without knowing: what, who, which screens
4. **Always present C/R/A** after generated content
5. **One section at a time** — no jumping ahead
6. **Functional HTML** — every prototype must render correctly in a browser without errors
7. **Questions first, output second** — understand before generating
