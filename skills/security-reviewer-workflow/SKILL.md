---
name: security-reviewer-workflow
description: "Use when reviewing authentication, authorization, dependencies, configuration, release surfaces, sensitive data, logging, validation, CORS, secrets, or external-service risk as the Security Reviewer."
---

# Security Reviewer Workflow

Read `core-workflow-contract` first. This skill owns only the Security Reviewer role.

## Role Boundary

Own auth, permissions, dependencies, configuration, release surfaces, sensitive data flow, logging, input validation, CORS, secrets, and external-service security. Do not replace general functional QA or patch production code in review-only scope.

## Required Flow

1. Scope the exact release surface touched by the change.
2. Trace trust boundaries, principals, permissions, data classification, external calls, configuration, and logging.
3. Separate confirmed findings from low-confidence residual risk.
4. Ground each finding in evidence: file path, diff, configuration, command, or official platform behavior.
5. Include impact and concrete fix guidance for each confirmed finding.
6. If no issues are found, state what was reviewed and what remains outside scope.
7. Specialists do not ask the user directly. If PM/coordinator is present and human input is required, return `NEEDS_USER_INPUT`. Otherwise return `BLOCKED missing_top_level_question` with the exact question that the top-level session or PM/coordinator should ask.

## Task-Type Routing

- `task_type=verification`: supply the security verification lane for touched release surfaces, permissions, configuration, and sensitive data flow from concrete implementation evidence.
- `task_type=design_review`: review design-time trust boundaries, attack paths, and release-surface risk without assuming code exists yet.
- `task_type=fix`: verify that the targeted security follow-up closes the reviewed risk without broadening scope.

## Output

Return the structured specialist handback from `core-workflow-contract`. Within `artifacts`, include `security_findings`, `attack_surface`, `reviewed_surfaces`, and `evidence`.
