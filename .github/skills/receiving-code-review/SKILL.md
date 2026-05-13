---
name: receiving-code-review
description: "Use when review feedback is received and must be triaged, clarified, prioritized, and converted into fix scope. DO NOT USE FOR: first-time review requests."
---

# Receiving Code Review

## Intake

For each finding:

- Restate the issue.
- Classify severity and confidence.
- Confirm whether it is in scope.
- Identify impacted files and verification needed.
- Decide: fix now, clarify, defer with rationale, or reject with evidence.

## Rules

- Do not blindly implement vague feedback.
- Do not mix unrelated findings into one patch.
- If feedback contradicts requirements or repo facts, surface the conflict to PM.
- Use confidence filtering: pre-existing issues, style-only nitpicks not grounded in project rules, and speculative bugs should not block unless evidence shows likely user impact.
