# MR/PR Comment Template

Repeat this block once per finding. Separate blocks with a `---` line.

```text
### Comment <N>

**File:** `<path/relative/to/repo/root>`
**Line:** <line number in the new version of the file, or range start-end>
**Severity:** <CRITICAL | MAJOR | MINOR | NIT>

<Body: plain markdown, never inside a blockquote (no leading `>`).
1. What is wrong, in one sentence.
2. Why it matters: the triggering input or state and the consequence.
3. The suggested fix, optionally as a `suggestion` code block.>
```

## Example

### Comment 1

**File:** `src/services/basket.ts`
**Line:** 42
**Severity:** MAJOR

`items` can be `undefined` when the upstream returns an empty basket, so `items.length` throws a `TypeError` and the endpoint responds with a 500.

Default to an empty array before reading the length:

```suggestion
const count = (items ?? []).length;
```
