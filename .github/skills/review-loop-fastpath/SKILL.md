---
name: review-loop-fastpath
description: "Use after review findings have been fixed and only affected scope should be re-reviewed. Reuses previously verified items instead of restarting full review."
---

# Review Loop Fastpath

## Steps

1. Read the previous findings and fixed files.
2. Re-check only the finding, direct blast radius, and verification gaps.
3. Reuse previously verified items unless the fix invalidates them.
4. Return status: `resolved`, `still_failing`, `new_risk`, or `needs_context`.
5. If the same review class repeats twice, emit an `evolution_signal` so PM can improve the relevant agent, skill, or verification checklist.

## Output

```markdown
## Re-review
- finding:
- status:
- evidence:
- remaining_risk:
```
