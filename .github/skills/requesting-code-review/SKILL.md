---
name: requesting-code-review
description: "Use before handing completed work to QA, security, or peer review. Prepares scope, intent, changed files, verification, and known risks."
---

# Requesting Code Review

## Review Packet

Include:

- Goal and user-facing behavior.
- Changed files and why they changed.
- Relevant spec or acceptance checks.
- Verification already run.
- Known gaps or risks.
- Areas reviewers should focus on.

## Rules

- Do not ask for broad review without scope.
- Public contracts, auth, data, dependencies, CI, runtime config, or browser UI changes must be highlighted.
- If verification is missing, say so before review.
- For larger changes, request independent perspectives: spec compliance, obvious bugs, historical context, comments/instructions compliance, and regression risk.
- Ask reviewers to filter low-confidence findings; actionable findings should include evidence and confidence, not only suspicion.
