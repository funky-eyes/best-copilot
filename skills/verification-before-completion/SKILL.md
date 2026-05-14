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
- If the current user-invocable role is about to end the turn, native closeout or continuation evidence exists unless the latest user message already came from that native gate and chose to end.
- If the task exposed a reusable workflow weakness, include an `evolution_signal` instead of silently moving on.

## Native Closeout UI Hard Gate

- A final prose response is allowed only after verification evidence is ready and closeout/continuation state is valid.
- If the role needs to ask whether to continue, choose a follow-up path, approve a next step, or end the turn, it must use `ask_user`, `vscode/askQuestions`, `askQuestions`, or equivalent native structured UI when available.
- Ordinary prose questions, "reply A/B/C" instructions, and summary-plus-question endings are not valid closeout evidence.
- If native ask UI is unavailable and a human choice is still required, report `BLOCKED` or `DONE_WITH_CONCERNS` with `missing_native_ask_ui`; do not claim normal completion.

## Final Evidence Format

```markdown
## Final Verification
- checks_run:
- passed:
- skipped:
- residual_risk:
```

Do not say “complete” before this check is done.
