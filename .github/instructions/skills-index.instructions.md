---
name: repo-skills-index
description: Lightweight repository skill index used to select one relevant skill without preloading every SKILL.md
applyTo: "**"
---

# Repo Skills Index

This file is only for discovery and routing. Match the current task to the index, then read the needed parts of `skills/<skill>/SKILL.md`. Do not preload the entire `skills` tree.

## Initialization and Orchestration

- `repo-init-scan`: first use in a target repository, placeholder project facts, missing target-local scaffolds, or `/init` / `copilot init` output that still needs to be normalized into reusable repo facts.
- `target-instructions-bootstrap`: create missing target-local `.github/instructions/**`, including the neutral project facts scaffold, and optional `AGENTS.md`.
- `target-memory-bootstrap`: create missing target-local `memories/repo/**` skeleton for persistent task recovery.
- `target-spec-bootstrap`: create missing target-local `spec/INDEX.md` and `spec/templates/**` before spec-driven work.
- `core-workflow-contract`: full team flow, init recovery, frozen packet rules, external capability fusion, handoff, memory/spec relationship, or closeout rules.
- `evolution-loop`: closeout, repeated failure, review loop, stale trigger, or user-requested agent/skill improvement; produces auditable and reversible evolution proposals.
- `brainstorming`: top-level or PM planning gate where route-changing ambiguity must be locked through explicit direction confirmation before spec or code.
- `writing-plans`: MEDIUM/LARGE tasks that need executable slices with files and verification.
- `spec-review-gauntlet`: pre-implementation readiness and multi-lane design review for Spec Bundles, execution plans, cross-module changes, and high-risk customization workflow changes.
- `executing-plans`: approved tasks.md or multi-step plan execution with checkpoints, verification evidence, and per-task review.
- `subagent-driven-development`: fresh-context specialist execution for approved plans, requiring implementation, spec-compliance review, code-quality review, and verification per task.
- `dispatching-parallel-agents`: independent frozen subtasks with non-overlapping write sets.

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
- `structured-review`: evidence-first code, customization, targeted re-review, or medium/large design review when a compact scenario router is preferable.
- `frontend-design-guardrails`: UI implementation guardrails for pages, components, forms, tables, and dashboards.
- `web-experience-audit`: browser behavior, visual quality, console/network, responsive, or accessibility evidence.
