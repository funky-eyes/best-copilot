---
name: subagent-driven-development
description: "Use when an approved tasks.md or implementation plan should be executed by fresh-context specialist subagents, with each task receiving implementation, spec-compliance review, code-quality review, and verification before closure. DO NOT USE FOR: missing plans, brainstorming, or simple single-file edits."
user-invocable: false
---

# Subagent Driven Development

Use this skill when a MEDIUM/LARGE plan is ready for implementation and fresh context would reduce cross-task contamination. The PM remains the controller: specialists implement or review bounded slices, and the PM adjudicates fan-in results.

## Preconditions

- A current plan or `tasks.md` exists and is approved for execution.
- Each task has a complete task statement, `files_involved`, dependencies, acceptance checks, and verification budget.
- PM has frozen `user_provided_paths`, `priority_files`, `already_read_files`, `authoritative_repo_facts`, `forbidden_approaches`, and `source_provenance_refs` when relevant.
- If the work came through PM planning, `execution_confirmed` must match the current `plan_revision`.

## Task Cycle

For every ready task:

1. Build a fresh context packet with `context-packet-fastpath`.
2. Dispatch implementation to the right specialist: Technical Architect for full-stack architecture/mainline slices, Developer for scoped slices, Frontend Designer for UI-owned slices, or Root Cause Fixer for confirmed failures.
3. Require implementation evidence: changed files, tests/checks run, key output, risk, and next-step notes.
4. Run Stage 1 review: spec/task compliance. The reviewer checks whether requirements, non-goals, file boundaries, and acceptance checks were honored.
5. Run Stage 2 review: code quality and release risk. The reviewer checks maintainability, coupling, security/performance risk, dead code, and test adequacy.
6. Send confirmed findings to a fix loop using `structured-review` feedback-intake and targeted re-review modes.
7. Only after the task passes the required reviews and verification may PM mark it complete.

Stage 1 and Stage 2 must not be performed by the same specialist who authored the implementation under review.

Default reviewer lanes:

- Developer-authored implementation -> Technical Architect.
- Technical Architect-authored implementation -> Developer.
- Frontend changes authored by Developer or Technical Architect -> Frontend Designer review before QA.
- Frontend Designer-authored implementation -> Technical Architect.
- Quality Assurance Expert performs final behavior/regression/test-sufficiency review after required peer lanes.

## Fresh Context Rules

- Do not pass long chat history to specialists.
- Pass verified facts, frozen paths, compact summaries, and recovery hints.
- If a previous task changed files, refresh `changed_files`, `inline_code_context`, and `already_read_files` before follow-up review or fix.
- Do not let one subagent's guesses become another subagent's facts.

## Fan-In Rules

- Accept only `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `NEEDS_USER_INPUT`, or `BLOCKED`.
- Every delegated specialist result must preserve the `core-workflow-contract` handback fields: `task_id`, `current_stage`, `status`, `summary`, `artifacts`, `risks`, `uncovered_items`, and `recommended_next_stage`.
- When `status=NEEDS_CONTEXT`, the handback must also include `clarification_request` and `pm_action: "pm_clarify"`.
- Completion-like results without verification evidence are incomplete.
- `DONE_WITH_CONCERNS` must list the concern impact and whether it blocks later tasks.
- Repeated `NEEDS_CONTEXT`, `NEEDS_USER_INPUT`, or the same blocker twice triggers PM re-analysis instead of another blind dispatch.

## Output Expected From PM

After using this skill, PM should be able to report:

- current task or batch status
- implementation owner and reviewer lanes
- Stage 1 and Stage 2 review outcomes
- verification evidence and coverage
- remaining blockers or next ready tasks
