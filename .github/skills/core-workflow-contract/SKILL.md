---
name: core-workflow-contract
description: "Detailed team workflow contract for planning, handoff, verification, memory/spec recovery, and closeout."
---

# Core Workflow Contract

## Source Priority

System/developer/user instructions > current repo files > spec > command evidence > repo memory > external references.

External repositories, skill libraries, and prompt systems are reference inputs only. Reuse their ideas by translating them into this repository's local primitives, not by copying their owner rules wholesale.

## Init And Fact Capture

This section is a fail-closed gate. If required repository facts or first-use scaffolds are missing, the only allowed work is official init, bounded manual fact capture, and target bootstrap file creation. Do not continue to substantive requirements analysis, package inspection for implementation, dependency upgrades, framework migrations, security rewrites, or code changes until the gate passes.

1. If the repository is new, under-documented, or still full of `/init` placeholders, prefer the official initializer before substantive analysis.
2. Judge init state from target repository files: `.github/instructions/project.instructions.md` must exist, be free of unresolved init placeholders, not be the untouched neutral scaffold, and record build/test/check/dev command facts plus runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown` gaps.
3. When shell execution is available, run `copilot init` directly. When only Copilot interactive slash commands are available, ask the user to run `/init`.
4. Immediately after official init, normalize useful output or artifacts into `.github/instructions/project.instructions.md`, then verify the target file exists and contains the required fact categories. Treat command output without the project facts file as `official_init_no_write`, not success.
5. If official init does not provide enough usable facts or leaves the project facts file incomplete, create or repair `.github/instructions/project.instructions.md` from bounded repo evidence before requirements analysis.
6. Do not rerun init on every conversation once the target repository has sufficient facts.
7. Initialization is not a closeout point: after init, continue the original task in the same conversation whenever possible.
8. Normalize discovered facts into short reusable repo facts: runtime/framework, build/test/dev commands, entrypoints, module boundaries, and major ownership surfaces.
9. After repository facts exist, create missing target-local scaffolds through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap` when those surfaces are absent or the current work needs them. Missing scaffolds alone do not justify rerunning official init, but they do block substantive task work until created or explicitly blocked.
10. Store persistent instructions/memory/spec state in the target repository, not in the installed plugin package or plugin cache.
11. Mark unknowns as `unknown`; do not guess missing repository facts.
12. Before leaving init, verify `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, `.github/instructions/skills-index.instructions.md`, `memories/README.md`, `memories/repo/INDEX.md`, `memories/repo/current-workstreams.md`, `memories/repo/project-state.md`, `memories/repo/workflow-rules.md`, `memories/repo/decisions.md`, `memories/repo/logs/README.md`, `memories/repo/archive/deprecated-decisions.md`, `spec/INDEX.md`, `spec/templates/requirements-template.md`, `spec/templates/design-template.md`, and `spec/templates/tasks-template.md` on disk. If verification fails, return `BLOCKED first_use_gate_incomplete` with missing paths.

## Default Flow

1. Init if repo facts are missing.
2. Parse intent and success criteria.
3. Freeze scope and non-goals, including explicit user paths, already-read context, authoritative repo facts, and forbidden approaches when they matter.
4. Plan if task is MEDIUM/LARGE.
5. Run `spec-review-gauntlet` before implementation when the task is MEDIUM/LARGE, cross-module, security-sensitive, dependency-affecting, or changes workflow routing.
6. Adjudicate design-review findings by `finding_kind`; `spec_blocker` and `clarification_needed` return to spec or native clarification, while `implementation_todo` and `risk_note` proceed with tracking.
7. Implement through the right specialist only after the current plan revision is execution-confirmed when planning produced a revision.
8. Execute multi-step plans with `subagent-driven-development` or `executing-plans`, not ad hoc serial coding.
9. For every implementation task, run Stage 1 spec-compliance review before Stage 2 code-quality/release-risk review, then verify with concrete evidence.
10. Close with memory/spec recovery notes when useful.
11. Evolve only from verified signals: repeated failures, user corrections, review loops, stale triggers, missing verification, or recurring workflow friction.

## Native Ask Flow

- Blocking clarification, route selection, execution approval, continuation, and closeout must use native structured UI when available: `ask_user` for Copilot CLI, or `vscode/askQuestions` / `askQuestions` / equivalent structured UI for VS Code.
- Prose-only questions never satisfy confirmation, continuation, or closeout gates and must not be used as the final turn.
- Answer-only user follow-ups, including why/how questions, rule clarifications, solution comparisons, and review-response discussion, are not closeout exemptions. If the answer would end the current batch, trigger a fresh native closeout prompt after answering and before ending.
- If the user has already authorized development, perform safe non-destructive setup directly. Ask only when a real human choice remains, and ask natively.
- If native UI is unavailable and there is no single safe interpretation, return a blocked/partial state with `missing_native_ask_ui` instead of pretending the turn is complete.

## Spec And Execution Gates

- MEDIUM/LARGE work must have a complete Spec Bundle or equivalent approved plan before implementation.
- Before implementation, use `spec-review-gauntlet` or `structured-review` design-review mode to check completeness, existing-code leverage, task granularity, traceability, TDD feasibility, blast radius, and handoff readiness.
- Default design-review lanes are Technical Architect, Developer, Quality Assurance Expert, and Security Reviewer; add Frontend Designer only for user-visible frontend work.
- PM must adjudicate findings before implementation. Only `implementation_todo` and `risk_note` can proceed without spec revision.
- Once the plan is approved, use `subagent-driven-development` for fresh-context specialist execution or `executing-plans` for inline checkpointed execution.
- A task is not complete until implementation evidence, Stage 1 spec-compliance review, Stage 2 code-quality/release-risk review, and verification coverage are recorded.
- Implementers may not sign off on their own authored files.

## External Capability Fusion

When the user asks to learn from another repository, agent, skill, or prompt system:

1. Extract only reusable patterns.
2. Re-express them as local primitives such as routing, frozen dispatch packets, output recovery, document intent, verification gates, and resume hints.
3. Reject repository-specific stack assumptions, model assignments, path layouts, and ownership boundaries that do not generalize.
4. Validate the fused result against current local files instead of trusting the external source.

## Handoff Rules

- PM sends minimal frozen packets.
- Frozen packets should include `user_provided_paths`, `priority_files`, `reference_files`, `already_read_files`, `authoritative_repo_facts`, `forbidden_approaches`, and `source_provenance_refs` when those fields exist.
- For approved plan execution, packets should also include `plan_revision`, `execution_confirmed`, `task_id`, task text, dependencies, acceptance checks, verification budget, and review lanes.
- Specialists do not ask the user directly when delegated.
- Specialists consume frozen paths and facts before reopening search.
- Missing context returns `NEEDS_CONTEXT`.
- Write sets must not overlap for parallel implementation.

## Memory / Spec

- Spec is authoritative for requirements, design, and tasks.
- Memory is only a recovery index: current focus, decisions, last verification, next action.
- EvolutionEvents are compact memory records for accepted workflow improvements; each needs signal, target, mutation, validation, rollback, and status.
- Do not store secrets, PII, raw long logs, or unverified guesses.
