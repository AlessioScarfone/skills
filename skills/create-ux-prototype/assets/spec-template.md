---
project: "My Project"
author: "Create UX Skill"
date: "YYYY-MM-DD"
status: in-progress
---

# UX Design Specification — [Project Name]

> This document is built progressively through a Create UX Skill session.
> Each section is added collaboratively after discussion and approval.

---

## Project Vision

**What we're building:**
<!-- Specific product, feature, or flow being designed -->

**Primary user:**
<!-- Who uses this and what they're trying to accomplish -->

**Core problem:**
<!-- What's frustrating or broken about existing solutions -->

**Platform:**
<!-- Web desktop / Mobile web / Cross-platform / Specific breakpoints -->

**Constraints:**
<!-- Brand, style, existing design system, technical limitations -->

**Success definition:**
<!-- What "good enough to test with users" looks like -->

---

## Design Decisions Log

<!-- Each row = one resolved design decision from the brainstorming workshop -->

| Decision | Choice Made | Rationale |
|---|---|---|
| Navigation pattern | <!-- Top bar / Side nav / Bottom tabs / Hamburger --> | |
| Content density | <!-- Spacious / Compact / Mixed --> | |
| Primary action placement | <!-- FAB / Top-right / Bottom bar / Contextual inline --> | |
| Information hierarchy | <!-- Single-focus / Dashboard overview / Progressive disclosure --> | |
| Color approach | <!-- Neutral+accent / Brand-first / Dark mode / System-aware --> | |
| Form interaction | <!-- Modal / Side panel / Inline / Separate page --> | |
| Feedback & states | <!-- Toast / Inline validation / Status banners --> | |

---

## Component Inventory

<!-- Reusable UI building blocks for this project -->

| Component | Variants | Notes |
|---|---|---|
| Button | Primary, Secondary, Destructive, Icon-only | |
| Input | Text, Search, Textarea | |
| Card | Default, Highlighted, Compact | |
| Badge / Tag | Status, Label, Count | |
| Navigation | *(based on decision)* | |
| Modal / Dialog | Confirmation, Form, Info | |
| Toast / Notification | Success, Error, Warning, Info | |
| Loading state | Skeleton, Spinner | |
| Empty state | No data, Error, Search no results | |

---

## Key Screen Wireframes

<!-- 2-3 most critical screens in text/ASCII wireframe format -->

### Screen 1 — [Name]

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                    HEADER ZONE                      │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                    CONTENT ZONE                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Annotations:**
- Zone 1: ...
- Zone 2: ...

---

### Screen 2 — [Name]

```
┌─────────────────────────────────────────┐
│                                         │
│  [Sketch the layout using ASCII art]    │
│                                         │
└─────────────────────────────────────────┘
```

**Annotations:**
- ...

---

### [Screen 3 — Edge Case / Empty State / Error]

```
┌─────────────────────────────────────────┐
│                                         │
│  [Sketch the layout using ASCII art]    │
│                                         │
└─────────────────────────────────────────┘
```

**Annotations:**
- <!-- Key layout or interaction note -->

---

## Prototype Specification

```
**PROTOTYPE SPECIFICATION**

<!-- Technical scope for the HTML prototype -->

Screens included:     <!-- list the screens to build -->
Interactions:         <!-- list clickable elements and what happens -->
NOT included:         <!-- back-end, auth, real data — anything out of scope -->
Breakpoints:          <!-- e.g., desktop 1200px, tablet 768px, mobile 375px -->
Design tokens:
  Colors:             <!-- hex codes for primary, secondary, background, text, error -->
  Typography:         <!-- font family, sizes (base, h1, h2, small) -->
  Spacing scale:      <!-- e.g., 4px / 8px / 16px / 24px / 32px / 48px -->
Browser target:       Modern browsers (Chrome, Firefox, Safari, Edge)
Accessibility:        ARIA labels, semantic HTML, keyboard navigation for nav

**PROTOTYPE INTERACTIONS**

<!-- What is clickable / interactive in the prototype -->

| Element | Interaction | Result |
|---|---|---|
| |  |  |

```

## Review Notes

<!-- Feedback and iteration notes after prototype review -->

| Round | Feedback | Status |
|---|---|---|
| v1 | | |

---

## HTML Prototype

> The HTML prototype is delivered as a complete standalone file in the Create UX Skill session.
> Copy the code block from the conversation and save as `prototype-[project-name].html`.
> Open directly in any browser — no server or dependencies required.

**File:** `prototype-[project-name].html`
**Status:** [ ] Not started / [ ] In progress / [ ] Complete

**Interactions implemented:**
- <!-- e.g., Side nav toggle on mobile -->
- <!-- e.g., Tab switching in dashboard -->
- <!-- e.g., Form validation on submit -->
