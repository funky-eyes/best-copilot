# Code Intelligence Fallback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `codebase-memory-mcp` the preferred structural code-intelligence provider in every supported runtime, with GitNexus, CodeGraph, LSP, and native search as capability-aware fallbacks.

**Architecture:** The shared workflow contract defines one provider order and maps the providers to discovery, context, impact, change-scope, refactoring, review, and verification work. Runtime adapters and target-bootstrap templates retain concise compatible wording that points to that policy.

**Tech Stack:** Markdown instruction files and POSIX shell bootstrap templates; no runtime dependency changes.

## Global Constraints

- Call only tools exposed by the current runtime; a configured plugin or local binary does not prove tool availability.
- Never block work merely because a preferred provider is absent.
- Preserve GitNexus-specific safeguards when GitNexus is the selected available provider.
- Do not modify plugin metadata, dependencies, or user project source files.

---

### Task 1: Define the shared capability policy

**Files:**
- Modify: `.github/instructions/must.instructions.md`
- Modify: `skills/core-workflow-contract/SKILL.md`
- Modify: `skills/core-workflow-contract/references/detailed-contract.md`

- [x] Define the provider order: codebase-memory-mcp, GitNexus, CodeGraph, LSP, then native search.
- [x] Map discovery, call-chain/context, impact/change-scope, refactoring, review, and verification to the strongest available capability.
- [x] Preserve non-blocking behavior and GitNexus freshness/change-detection rules when that provider is selected.

### Task 2: Update runtime adapters and review guidance

**Files:**
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`
- Modify: `.github/instructions/project.instructions.md`
- Modify: `claude-agents/*.md`
- Modify: `skills/senior-project-expert-workflow/SKILL.md`
- Modify: `skills/structured-review/references/code-review.md`

- [x] Replace stale GitNexus-first text with the shared provider order.
- [x] Require agents to record the selected provider and use its relationship evidence to improve scoped implementation and review quality.

### Task 3: Propagate the policy to generated target repositories

**Files:**
- Modify: `skills/target-instructions-bootstrap/references/templates.md`
- Modify: `skills/repo-init-manual-fallback/inline-templates-reference.md`
- Modify: `skills/repo-init-manual-fallback/scripts/bootstrap-target-scaffold.sh`

- [x] Keep generated Codex and Claude instructions aligned with the shared policy.

### Task 4: Verify policy consistency

**Files:**
- Verify: all files above

- [x] Run fixed-string residual scans for obsolete GitNexus-first wording.
- [x] Run shell syntax validation for the changed bootstrap script.
- [x] Inspect the final diff for scope and template consistency.
