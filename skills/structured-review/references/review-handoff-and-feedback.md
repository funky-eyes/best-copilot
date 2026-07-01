# Review Handoff And Feedback Intake

Use this reference when preparing a review request, triaging reviewer feedback, or converting accepted feedback into a fix scope. It replaces separate review-request and review-intake skills so agents use one review workflow.

## Review Handoff

Before asking another reviewer to inspect completed work, prepare a bounded packet:

- goal and user-facing behavior
- changed files and why they changed
- context-chain targets: changed public surface plus direct callers/importers, downstream callees/consumers, routes/API shape, state owners, or the reason no runtime consumer exists
- relevant spec, requirements, or acceptance checks
- verification already run, with command/check evidence
- known gaps, risks, and skipped checks
- review focus areas such as spec compliance, correctness, security, frontend UX, tests, customization contract, or regression risk
- `artifact_refs`: final diff/review package, context-chain map, verification output, prior review findings, and state-sync refs when they exist
- `base_head_or_revision` and freshness check for diff/context artifacts
- `input_boundary`: trusted instructions, untrusted evidence, author claims, and forbidden controller/author severity or merge framing
- `permission_boundary`: `read_only_review` by default, write set `none`, and fix owner if findings are accepted

Do not request a broad review without scope. Highlight public contracts, auth, data, dependencies, CI, runtime config, browser UI, tools, permissions, memory, or workflow-routing changes. The final independent aggregate review is the only broad-review exception: scope it to the final changed branch/package plus artifact refs, require a non-author reviewer, and hide prior controller approval/severity framing until after the reviewer forms an evidence-based verdict.

## Feedback Intake

For each finding or reviewer comment:

1. Restate the issue in neutral terms.
2. Classify severity, confidence, and origin.
3. Decide whether it is in the current scope or pre-existing.
4. Identify impacted files and verification needed.
5. Decide: fix now, clarify, defer with rationale, or reject with evidence.
6. Convert accepted fixes into `review_followup_scope` with exact files and checks.

Do not blindly implement vague feedback. If feedback conflicts with requirements, repository facts, or user direction, surface the conflict to PM or the user through native clarification when needed.

## Fix Scope Rules

- Do not mix unrelated findings into one patch.
- Do not reopen full discovery for a targeted fix unless the finding proves the original scope was wrong.
- Reuse previously verified items unless the fix invalidates them.
- If the same review class repeats twice, emit an `evolution_signal` with the failing trigger or checklist gap.

## Output Template

```markdown
## review_handoff_or_intake
- mode: handoff | intake | fix-scope | final-aggregate-review
- scope:
- artifact_refs:
- input_boundary:
- permission_boundary:
- findings_or_focus:
- context_chain_targets:
- accepted_fixes:
- rejected_or_deferred:
- verification_needed:
- residual_risk:
```
