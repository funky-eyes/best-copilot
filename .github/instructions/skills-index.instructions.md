---
name: repo-skills-index
description: Lightweight repository skill index used to select one relevant skill without preloading every SKILL.md
applyTo: "**"
---

# Repo Skills Index

This file is only for discovery and routing. Match the current task to the index, then read the needed parts of `skills/<skill>/SKILL.md`. Do not preload the entire `skills` tree.

## Initialization and Orchestration

- `senior-project-expert`: compatibility skill for runtimes that resolve the Senior Project Expert request as a skill instead of the Senior Project Expert agent; it loads the PM workflow and runs the same mandatory init preflight before substantive target-repository work.
- Claude Code stable Senior entry: use `--agent senior-project-expert`, the Claude `agent` setting, `/agents` with the displayed name, or `@best-copilot:senior-project-expert` when the UI accepts it as a subagent invocation. If `@` is treated as plain text, prefer `--agent` or the `agent` setting for reliable first-use gates.
- `repo-init-gate`: read only the target root `best-copilot.md` and decide whether the current init contract version is already satisfied.
- `repo-init-scan`: heavy init/repair flow used only after `repo-init-gate` fails. Typical triggers are first use in a target repository, placeholder or stale project facts, missing or mismatched `best-copilot.md`, missing target-local scaffolds, or `/init` / `copilot init` output that still needs to be normalized into reusable repo facts.
- `repo-init-official`: official initializer stage used inside `repo-init-scan` before manual fallback; it runs a target-local `init` skill first when discoverable and mechanically invokable, then Claude native `/init` or Copilot `copilot init`.
- `repo-init-manual-fallback`: bounded manual scan, scaffold bootstrap, artifact verification, and sentinel rewrite used when official init is unavailable or incomplete.
- `target-instructions-bootstrap`: create missing target-local `.github/instructions/**`, including the neutral project facts scaffold, plus runtime adapters such as `AGENTS.md` for Codex and `CLAUDE.md` for Claude Code when applicable.
- `target-memory-bootstrap`: create missing target-local `memories/repo/**` skeleton for persistent task recovery.
- `target-spec-bootstrap`: create missing target-local `spec/INDEX.md` and `spec/templates/**` before spec-driven work.
- `core-workflow-contract`: shared cross-role source priority, runtime adapters, init gates, work modes, dispatch packet shape, review/verification, memory/spec, state persistence, and closeout rules.
- Role workflow skills: load one matching the active agent role together with `core-workflow-contract`.
  - `senior-project-expert-workflow`: PM/coordinator scope, routing, dispatch, fan-in, closeout, and evolution signals.
  - `specification-writer-workflow`: requirements, design, tasks, ADRs, closeout records, and memory/spec recovery.
  - `technical-architect-workflow`: full-stack architecture, SDD design brainstorming, service boundaries, data/API contracts, blast radius, mainline implementation, parallel decomposition, and cross-review.
  - `developer-workflow`: frozen implementation slices, scoped peer review, `NEEDS_CONTEXT` / `NEEDS_USER_INPUT`, and verification evidence.
  - `frontend-designer-workflow`: UI implementation/review, design-system reuse, responsive/browser evidence, and visual quality.
  - `quality-assurance-workflow`: functional verification, regression risk, test sufficiency, and merge-readiness review.
  - `security-reviewer-workflow`: auth, permissions, dependencies, secrets, release surfaces, and sensitive data review.
  - `root-cause-fixer-workflow`: concrete failure evidence, minimal root-cause patching, and regression proof.
- `evolution-loop`: closeout, repeated failure, review loop, stale trigger, or user-requested agent/skill improvement; produces auditable and reversible evolution proposals.
- `brainstorming`: top-level or PM planning gate where route-changing ambiguity must be locked through explicit direction confirmation before spec or code; PM-led large technical design routes deep brainstorming through Technical Architect.
- `writing-plans`: MEDIUM/LARGE tasks that need executable slices with files and verification; persistent MEDIUM/LARGE output belongs in `spec/<feature>/tasks.md`, not a standalone plan file.
- `spec-review-gauntlet`: pre-implementation readiness and multi-lane design review for Spec Bundles, execution plans, cross-module changes, and high-risk customization workflow changes; MEDIUM/LARGE target work must have `requirements.md`, `design.md`, and `tasks.md` in one spec directory before implementation.
- `executing-plans`: approved tasks.md or multi-step plan execution with checkpoints, verification evidence, per-task review, and durable state sync.
- `subagent-driven-development`: fresh-context specialist execution for approved plans, requiring implementation, spec-compliance review, code-quality review, verification, and state sync per task.
- `dispatching-parallel-agents`: independent frozen subtasks with non-overlapping write sets.
- `workspace-isolation`: before approved implementation or substantial feature/fix work when branch/worktree isolation, provenance, or baseline setup must be decided.

## Context, Implementation, and Debugging

- `search-fastpath`: target files are unclear or search is becoming expensive.
- `context-packet-fastpath`: prepare or consume a minimal frozen context packet.
- `spec-execution-fastpath`: clear requirement/spec, minimal reading, minimal diff.
- `td-java-coding-guidelines`: Java implementation or review involving Tongdun/Alibaba Java rules, exceptions/logging, SQL/MyBatis, security, middleware, concurrency, or virtual threads.
- `td-python-coding-guidelines`: Python implementation or review involving Google Python style, imports, naming, docstrings, exceptions, logging, typing, lint, or style migration.
- `test-driven-development`: new behavior or bug fix needs RED-GREEN-REFACTOR.
- `systematic-debugging`: unknown root cause, failing tests, incidents, or complex unexpected behavior.
- `root-cause-investigation`: failure evidence exists and likely file set is narrow.

## Verification, Review, and Experience

- `change-verification`: minimal sufficient command, HTTP, browser, or static evidence after changes.
- `verification-before-completion`: final check before claiming completion.
- `development-branch-closeout`: final branch/worktree decision after verification evidence exists.
- `structured-review`: evidence-first code, customization, targeted re-review, or medium/large design review when a compact scenario router is preferable.
- `frontend-design-guardrails`: UI implementation guardrails for pages, components, forms, tables, and dashboards.
- `web-experience-audit`: browser behavior, visual quality, console/network, responsive, or accessibility evidence.
