# Targeted Re-review

Use when the user asks whether previous findings were fixed, or provides a follow-up patch after review.

## Review scope

Do not restart a full review by default. Focus on:

- `review_followup_scope` or explicitly referenced previous findings
- changed lines related to the fix
- direct blast radius of the fix
- whether previously verified items still apply
- whether the fix introduced a new `Critical` issue

Only reopen a full review when:

- the patch changes unrelated architecture or broad behavior
- the fix touches many new files outside the expected blast radius
- a new high-confidence `Critical` issue appears
- the user explicitly requests full re-review

## Checklist

- Was each previous finding actually fixed?
- Is the fix minimal and scoped?
- Does the fix create new correctness/security/resource risk?
- Are tests or verification commands updated and run?
- Are any findings still open?
- Are there new issues inside the fix blast radius?

## Output template

```markdown
## review_scope
- previous findings checked:
- files/areas checked:
- out of scope:

## resolved_findings
- ...

## still_open_findings
- [Critical|Important|Minor][confidence=NN][origin=...] file:line | issue | impact | evidence | fix

## new_findings_in_blast_radius
- ...

## summary
- re-review result: fixed / partially fixed / not fixed / needs context
- next verification:
```
