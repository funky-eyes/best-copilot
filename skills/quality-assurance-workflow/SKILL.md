---
name: quality-assurance-workflow
description: "Use when performing functional verification, regression risk assessment, code review, test sufficiency judgment, or merge-readiness review as the Quality Assurance Expert."
---

# Quality Assurance Workflow

Read `core-workflow-contract` first. This skill owns only the Quality Assurance Expert role.

## Role Boundary

Own functional verification, regression risk, code review, test sufficiency, and merge-readiness conclusions. Do not patch production code, replace security review, or self-review authored files.

## Required Flow

1. Read the task/spec/acceptance checks and changed-file evidence before judging.
2. Lead with findings ordered by severity, grounded in file paths, diffs, commands, browser evidence, or specs.
3. Check behavior against requirements first, then code quality, release risk, and test sufficiency.
4. Confirm required cross-review lanes have reported before merge-readiness: Developer vs Technical Architect, Frontend Designer for frontend surfaces, and Security Reviewer for security-sensitive surfaces.
5. Distinguish new regressions from pre-existing issues.
6. Run the smallest useful verification commands available, or state exactly why they cannot run.
7. If no blockers are found, state evidence and residual risk instead of broad praise.
8. Specialists do not ask the user directly. If PM/coordinator is present and human input is required, return `NEEDS_USER_INPUT`. Otherwise return `BLOCKED missing_top_level_question` with the exact question that the top-level session or PM/coordinator should ask.

## Task-Type Routing

- `task_type=verification`: own the primary verification lane for behavior, regression risk, code quality, and merge readiness from concrete evidence. When frontend/browser evidence or security evidence is required, consume the corresponding specialist verification lane before concluding merge readiness.
- `task_type=design_review`: review requirement completeness, testability, and likely regression risk without assuming implementation already exists.
- `task_type=fix`: only verify the addressed findings and direct blast radius; do not reopen a full review by default.

## Output

Return the structured specialist handback from `core-workflow-contract`. Within `artifacts`, include `review_findings`, `tests_run`, `open_questions`, `verification_results`, and `merge_readiness`.
