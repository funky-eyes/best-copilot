---
name: core-workflow-contract
description: "Detailed team workflow contract for planning, handoff, verification, memory/spec recovery, and closeout."
---

# Core Workflow Contract

## Source Priority

System/developer/user instructions > current repo files > spec > command evidence > repo memory > external references.

External repositories, skill libraries, and prompt systems are reference inputs only. Reuse their ideas by translating them into this repository's local primitives, not by copying their owner rules wholesale.

## Init And Fact Capture

1. If the repository is new, under-documented, or still full of `/init` placeholders, prefer the official initializer before substantive analysis.
2. Judge init state from target repository files: `.github/copilot-instructions.md` must exist, be free of unresolved init placeholders, and record build/test/check/dev command facts plus runtime/framework, entrypoint, and module-boundary facts or explicit `unknown` gaps.
3. When shell execution is available, run `copilot init` directly. When only Copilot interactive slash commands are available, ask the user to run `/init`.
4. Do not rerun init on every conversation once the target repository has sufficient facts.
5. Initialization is not a closeout point: after init, continue the original task in the same conversation whenever possible.
6. Normalize discovered facts into short reusable repo facts: runtime/framework, build/test/dev commands, entrypoints, module boundaries, and major ownership surfaces.
7. Store persistent memory/spec state in the target repository, not in the installed plugin package or plugin cache.
8. Mark unknowns as `unknown`; do not guess missing repository facts.

## Default Flow

1. Init if repo facts are missing.
2. Parse intent and success criteria.
3. Freeze scope and non-goals, including explicit user paths, already-read context, authoritative repo facts, and forbidden approaches when they matter.
4. Plan if task is MEDIUM/LARGE.
5. Review design when blast radius is non-trivial.
6. Implement through the right specialist.
7. Verify with concrete evidence.
8. Close with memory/spec recovery notes when useful.
9. Evolve only from verified signals: repeated failures, user corrections, review loops, stale triggers, missing verification, or recurring workflow friction.

## Native Ask Flow

- Blocking clarification, route selection, execution approval, continuation, and closeout must use native structured UI when available: `ask_user` for Copilot CLI, or `vscode/askQuestions` / `askQuestions` / equivalent structured UI for VS Code.
- Prose-only questions never satisfy confirmation, continuation, or closeout gates and must not be used as the final turn.
- If the user has already authorized development, perform safe non-destructive setup directly. Ask only when a real human choice remains, and ask natively.
- If native UI is unavailable and there is no single safe interpretation, return a blocked/partial state with `missing_native_ask_ui` instead of pretending the turn is complete.

## External Capability Fusion

When the user asks to learn from another repository, agent, skill, or prompt system:

1. Extract only reusable patterns.
2. Re-express them as local primitives such as routing, frozen dispatch packets, output recovery, document intent, verification gates, and resume hints.
3. Reject repository-specific stack assumptions, model assignments, path layouts, and ownership boundaries that do not generalize.
4. Validate the fused result against current local files instead of trusting the external source.

## Handoff Rules

- PM sends minimal frozen packets.
- Frozen packets should include `user_provided_paths`, `priority_files`, `reference_files`, `already_read_files`, `authoritative_repo_facts`, `forbidden_approaches`, and `source_provenance_refs` when those fields exist.
- Specialists do not ask the user directly when delegated.
- Specialists consume frozen paths and facts before reopening search.
- Missing context returns `NEEDS_CONTEXT`.
- Write sets must not overlap for parallel implementation.

## Memory / Spec

- Spec is authoritative for requirements, design, and tasks.
- Memory is only a recovery index: current focus, decisions, last verification, next action.
- EvolutionEvents are compact memory records for accepted workflow improvements; each needs signal, target, mutation, validation, rollback, and status.
- Do not store secrets, PII, raw long logs, or unverified guesses.
