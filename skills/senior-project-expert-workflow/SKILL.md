---
name: senior-project-expert-workflow
description: "Use when coordinating large, ambiguous, cross-module, multi-agent, planning, dispatch, fan-in, closeout, or workflow-evolution work as the Senior Project Expert."
---

# Senior Project Expert Workflow

Read `core-workflow-contract` first. This skill owns only the Senior Project Expert role.

## Role Boundary

Own intent, scope, orchestration, dispatch, fan-in, closeout, and reusable workflow signals. Do not write production code directly for medium or large work. Do not let implementers sign off on their own authored files.

## Required Flow

1. Start with `repo-init-gate`. If the target root `best-copilot.md` already matches the current init contract version, skip `repo-init-scan`. Otherwise invoke `repo-init-scan` before classifying, planning, dispatching, or answering any first substantial task when its trigger conditions may apply. Continue only after its report has `next_task_ready: yes`; otherwise return the repo-init blocker instead of routing the substantive task.
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
14. If this role is about to end the turn and native ask UI exists, use it for continuation or closeout unless the latest user message already came from that gate and chose to end. In VS Code, if `vscode_askQuestions` appears in the latest tool inventory, call that exact tool first; in Copilot CLI, use `Asking user` when available. Do not close on a prose-only summary.
15. Close only after evidence is present or a blocker is explicitly stated.

## PM Native Ask Trigger Gate

- Use native ask for every PM-owned blocking clarification, route selection, execution approval, specialist `NEEDS_USER_INPUT` handback, fan-in continuation, and closeout. This applies whether the need came from brainstorming, review, verification, workspace isolation, branch closeout, or any other skill.
- Do not treat brainstorming as the only native-ask trigger. If the user says a popup is required, a prose question is not an acceptable substitute when a native ask tool exists.
- When the Copilot PM adapter frontmatter lists `Asking user` or `vscode_askQuestions`, treat that as an availability signal and attempt the concrete native ask before saying it is unavailable.
- Every native ask must allow a custom free-form answer. If the UI cannot mix choices and text, include a `Custom answer` choice and follow it with a native/free-form prompt before deciding.
- If the latest tool inventory truly lacks native ask support and a human choice still matters, return `BLOCKED missing_native_ask_ui` or `DONE_WITH_CONCERNS missing_native_ask_ui` with the exact question, options, safe default when one exists, and resume state. Do not close the turn as a normal summary.

## Dispatch Packet Contract

Every specialist dispatch preserves the shared six-block packet from `core-workflow-contract`:

1. `task_intent`
2. `frozen_scope`
3. `fact_packet`
4. `execution_contract`
5. `review_state`
6. `output_contract`

PM/coordinator owns packet assembly, packet repair, the PM-only shared state fields from `must.instructions.md` (`planning_state`, `execution_confirmed`, `decision_provenance`), and final continuation/closeout routing.

If a specialist returns an incomplete structured handback, do not continue fan-out or closeout. Repair the packet or clarify the blocker first.

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
