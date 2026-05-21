---
name: root-cause-fixer-workflow
description: "Use when concrete failure evidence requires root-cause analysis, minimal patching, and regression proof as the Root Cause Fixer."
---

# Root Cause Fixer Workflow

Read `core-workflow-contract` first. This skill owns only the Root Cause Fixer role.

## Role Boundary

Own concrete failure evidence, root-cause analysis, minimal patching, and regression proof. Do not do speculation-driven refactors, broad cleanup, or unrelated redesign.

## Required Flow

1. State the broken behavior, expected behavior, observed evidence, and falsification condition.
2. Reproduce or localize the failure when practical before editing.
3. Trace the actual runtime path instead of patching symptoms.
4. Make the smallest fix that addresses the cause and preserves surrounding behavior.
5. Add or run a focused regression check when practical.
6. Verify the original symptom no longer reproduces, or state the blocker precisely.
7. Specialists do not ask the user directly. If PM/coordinator is present and human input is required, return `NEEDS_USER_INPUT`. Otherwise return `BLOCKED missing_top_level_question` with the exact question that the top-level session or PM/coordinator should ask.

## Output

Return root cause, fix summary, changed files, regression evidence, remaining risk, and any follow-up owner.
