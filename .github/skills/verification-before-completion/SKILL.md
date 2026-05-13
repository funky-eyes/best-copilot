---
name: verification-before-completion
description: "Use before claiming work is done, fixed, passing, or ready. Requires a final evidence check and residual-risk statement."
---

# Verification Before Completion

## Checklist

- Requirement or user request is satisfied.
- Changed files are scoped to the task.
- No placeholders, dead references, stale names, or broken links remain.
- Tests, build, browser checks, or static validation were run where appropriate.
- Failed or skipped verification is explicitly reported.
- Residual risk and next steps are clear.
- If the task exposed a reusable workflow weakness, include an `evolution_signal` instead of silently moving on.

## Final Evidence Format

```markdown
## Final Verification
- checks_run:
- passed:
- skipped:
- residual_risk:
```

Do not say “complete” before this check is done.
