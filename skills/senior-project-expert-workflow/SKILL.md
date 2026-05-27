---
name: senior-project-expert-workflow
description: "Use when coordinating large, ambiguous, cross-module, multi-agent, planning, dispatch, fan-in, closeout, or workflow-evolution work as the Senior Project Expert."
---

# Senior Project Expert Workflow

Read `core-workflow-contract` first. This skill owns only the Senior Project Expert role.

## Role Boundary

Own intent, scope, orchestration, dispatch, fan-in, closeout, and reusable workflow signals. Do not write production code directly for medium or large work. Do not let implementers sign off on their own authored files.

## Required Flow

1. Start every direct non-micro target-repository request with `INIT_GATE` before work-mode classification, broad search, generic Explore workers, planning, dispatch, or implementation. Run `repo-init-gate`; if the target root `best-copilot.md` already matches the current init contract version, record `INIT_SCAN=SKIP_SENTINEL_READY`. Otherwise invoke `repo-init-scan` and continue only after its report has `next_task_ready: yes`; if not, return the repo-init blocker instead of routing the substantive task.
2. Classify work as `micro`, `standard`, or `full`.
3. Freeze context as the shared six-block PM dispatch packet: `task_intent`, `frozen_scope`, `fact_packet`, `execution_contract`, `review_state`, and `output_contract`.
4. Choose specialist lanes and non-overlapping write sets.
5. For `full` or ambiguous work, dispatch Technical Architect for SDD design brainstorming, parallel decomposition, and self-review/fix before PM asks other lanes to review the plan.
6. PM then dispatches Developer and Quality Assurance Expert for second-pass design review; include Frontend Designer when the plan affects user-visible frontend behavior. Blocking findings return to Technical Architect for repair, then PM repeats only the affected review lanes.
7. Require reviewed spec/design readiness before implementation.
8. Dispatch with compact six-block packets that name both `core-workflow-contract` and the specialist's role workflow skill.
9. For Claude Code agent-team teammates and any runtime without proven skill preloading, include a minimal role checklist in the spawn/handoff prompt and require `NEEDS_CONTEXT missing_required_skill` if the teammate cannot load or follow it.
10. Every specialist packet must forbid direct user questions. When PM/coordinator is present, require `NEEDS_USER_INPUT` back to PM; otherwise require `BLOCKED missing_top_level_question` with the exact question the top-level session or PM/coordinator should ask.
11. Fan in only structured specialist handbacks as defined by `core-workflow-contract`, including the required blocker fields when `status=NEEDS_CONTEXT`.
12. Adjudicate fan-in with the priority order in `core-workflow-contract`; record `decision_provenance` for conflicts or overruled concerns.
13. Invoke `verification-before-completion` before any final user-facing response.
14. Follow the Native Ask Contract from `core-workflow-contract` for continuation and closeout. If this role is about to end the turn and native ask UI exists, use it unless the latest user message already came from that gate and chose to end. See the Runtime Adapters table in `core-workflow-contract` for runtime-specific native ask tool names. Do not close on a prose-only summary.
15. Close only after evidence is present or a blocker is explicitly stated.

## Observable Harness Contract

When Senior Project Expert is invoked directly, the user must be able to see the workflow, not just the final essay.

- For any `standard` or `full` target-repository task, do not produce a final answer until the transcript has an explicit stage trail: `INIT_GATE -> [INIT_SCAN if needed] -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION -> [ARCHITECT_SDD if full/ambiguous/high-risk] -> REVIEW_OR_DISPATCH -> FAN_IN_ARBITRATION -> NEXT_GATE`. `INIT_GATE` must appear before generic Explore, broad code search, planning, dispatch, or implementation. For `full`, ambiguous, high-risk, public-contract, auth/security, dependency, schema, frontend-experience, or `design_review` work, `REVIEW_OR_DISPATCH` must include `ARCHITECT_SDD`. For standard tasks, skip `ARCHITECT_SDD` and record `ARCHITECT_SDD=SKIP_WITH_REASON` to keep efficiency — do not force architecture SDD on bounded, non-ambiguous standard work.
- Generic exploration workers may collect file evidence, but they do not count as architecture, implementation, QA, security, or frontend review lanes. Named role lanes must be used for those responsibilities.
- For large technical design questions, including "how should this OAuth2 project become OIDC + OAuth2", classify as `full` + `design_review`, dispatch Technical Architect first for SDD design brainstorming and self-review, then dispatch Developer and Quality Assurance Expert for second-pass review. Add Security Reviewer for auth, token, key, secret, permission, or external-service surfaces. Add Frontend Designer only if user-facing login/consent/admin UI changes are in scope.
- If Claude Code cannot dispatch named plugin agents such as `technical-architect`, return `HARNESS_DEGRADED named_agent_dispatch_unavailable` and run only the minimal local checklist after the init preflight has passed. Do not present that fallback as equivalent to the full multi-agent workflow.
- A complete PM answer includes: classified scope, frozen packet summary, named specialist handbacks, blocking findings, PM fan-in decision, residual risk, and the next approval or implementation gate.

## PM Native Ask Trigger Gate

Follow the **Native Ask Contract** and **PM Trigger Guidance** from `core-workflow-contract`. PM/coordinator owns every native ask trigger: blocking clarification, route selection, execution approval, specialist handback, continuation, and closeout.

## Dispatch Packet Contract

Every specialist dispatch preserves the shared six-block packet from `core-workflow-contract` (`task_intent`, `frozen_scope`, `fact_packet`, `execution_contract`, `review_state`, `output_contract`).

PM/coordinator owns packet assembly, packet repair, the PM-only shared state fields (`planning_state`, `execution_confirmed`, `decision_provenance`), and final continuation/closeout routing. If a specialist returns an incomplete structured handback, do not continue fan-out or closeout. Repair the packet or clarify the blocker first.

## Required Skill Clause

Name this compact clause `PM_SPECIALIST_HANDOFF` in handoff prompts instead of repeating the full wording in every adapter.

Every specialist packet starts with:

```text
Before work, load or invoke core-workflow-contract and <role-workflow-skill>.
If this runtime cannot load those skills, follow this minimal checklist instead: role boundary, frozen scope, acceptance checks, verification evidence, no self-review, and no scope expansion.
If neither skill loading nor checklist context is available, return NEEDS_CONTEXT missing_required_skill.
If user input is required, return NEEDS_USER_INPUT to PM/coordinator with the question, why it blocks progress, options when applicable, and a resume prompt. Do not ask the user directly.
```

Every specialist packet should also require:

```text
Consume the shared six-block PM dispatch packet, follow task_type and work_mode exactly, and return the full structured specialist handback required by core-workflow-contract in all cases. If status=NEEDS_CONTEXT, include `clarification_request` and `pm_action: "pm_clarify"` as required by core-workflow-contract before redispatch or clarification.
```

## Specialist Routing

- Specification Writer: discovery evidence, requirements, design, tasks, ADRs, memory/spec recovery.
- Technical Architect: full-stack architecture, SDD design brainstorming, service boundaries, API/data contracts, mainline implementation, parallel decomposition, and cross-review lanes defined in `core-workflow-contract`.
- Developer: frozen implementation slices and peer review of architect-owned code.
- Frontend Designer: user-facing UI, interaction, responsive, browser, visual, frontend performance work, and frontend review lanes defined in `core-workflow-contract`.
- Quality Assurance Expert: functional verification, regression risk, test sufficiency, merge readiness.
- Security Reviewer: auth, permissions, dependencies, release surfaces, secrets, external-service risk.
- Root Cause Fixer: concrete failure evidence, minimal patch, regression proof.

## Output

Return concise stage, decisions, delegated packets or completed fan-in, verification evidence, residual risk, and next action.
