# Task Rules

## Planning Process

### Step 1: Stay read-only

Do not write code during planning. The output is a plan document, not an implementation.

- Read the spec, including its `context`.
- Open the files listed in `context.relevant_code` when a task needs a precise location or pattern.
- Map dependencies between components and note risks.

### Step 2: Map the dependency graph

```text
Database schema
    │
    ├── API models/types
    │       ├── API endpoints
    │       │       └── Frontend API client
    │       │               └── UI components
    │       └── Validation logic
    └── Seed data / migrations
```

Implementation order follows the graph bottom-up: build foundations first.

### Step 3: Slice vertically

Build one complete feature path at a time, not one layer at a time.

**Bad (horizontal):**

```text
Task 1: Build entire database schema
Task 2: Build all API endpoints
Task 3: Build all UI components
```

**Good (vertical):**

```text
Task 1: User can create an account (schema + API + UI for registration)
Task 2: User can log in (auth schema + API + UI for login)
```

Each vertical slice delivers working, testable functionality.

### Step 4: Order and checkpoint

1. Satisfy dependencies first.
2. Leave the system in a working state after each task.
3. Add a verification checkpoint every 2–3 tasks, using the commands from `context.commands`.
4. Put high-risk tasks early (fail fast).

## Plan File Format

### Checkboxes
- `- [ ] 1.1 Pending task`
- `- [x] 1.1 Completed task`
- `- [ ]* 1.1 Optional task` (nice-to-have, not blocking)

### Numbering
- Top-level groups: `1.`, `2.`, `3.`; tasks: `2.1`, `2.2`.
- Maximum 2 levels (no `2.1.1`).
- Group headers are not executed directly; they are done when all their tasks are done.

### Requirement references
- Tag every task with the requirement ID(s) it satisfies: `_(LOGIN.1)_` or `_(LOGIN.1, AUTH.2)_`.
- The ID is `<GROUP_KEY>.<requirement-id>` as defined in the spec (full ACID: `<spec-name>.<GROUP_KEY>.<ID>`).
- Every requirement under `components` and `constraints` must be covered by at least one task.

## Task Content

Each task includes:
- **Clear objective** — what to implement.
- **Implementation details** — sub-bullets with file paths and patterns from `context`.
- **Requirement reference** — for traceability.

## Guidelines

- Coding tasks only — no deployment, manual testing, or documentation tasks.
- Incremental — each task builds on the previous one.
- Actionable by an agent — specific enough to implement without re-reading the codebase from scratch.
- Test-driven where appropriate — mark optional test tasks with `*`.
- Never invent commands: when `context.commands` lacks one, write the checkpoint as a behavior to verify and state that the command is unknown.

## Task Sizing

| Size | Files | Scope | Example |
|------|-------|-------|---------|
| **XS** | 1 | Single function or config change | Add a validation rule |
| **S** | 1-2 | One component or endpoint | Add a new API endpoint |
| **M** | 3-5 | One feature slice | User registration flow |
| **L** | 5-8 | Multi-component feature | Search with filtering and pagination |
| **XL** | 8+ | **Too large — break it down** | — |

Break a task down further when:
- Its requirement cannot be described in 3 or fewer bullet points.
- It touches two or more independent subsystems.
- Its title contains "and" (a sign it is two tasks).
