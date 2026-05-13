---
id: project-state
type: project-memory
updated_at: 2026-05-13
status: active
priority: medium
tags: [project, state, constraints, best-copilot]
---

# Project State

## One-line Summary

`best-copilot` is an installable Copilot CLI agent-team plugin and reusable Copilot/Codex customization template.

## Current State

- Current focus: publish-ready generalization of the self-evolving agent team, plugin manifest, first-use init workflow, README, and default skill set.
- Key acceptance signals: `.github/plugin/marketplace.json` exists; root `plugin.json` exists; English README explains marketplace install/team/evolution flow and links localized README files; First-use init has an explicit file-based detection rule; target repository memory/spec storage is separated from plugin package state; Frontend Designer documents model-specific design reasoning; `.github` remains canonical and English-only; `.codex` remains a thin bridge; default skills are concise and generic.
- Current risk: marketplace install should be smoke-tested with a current Copilot CLI after publishing/pushing the latest repository state.

## Constraints

- `.github/**` is the canonical source for Copilot agents, skills, prompts, and instructions.
- `.codex/**` should remain adapter-only and should not fork the canonical `.github` content.
- New repositories should run Copilot `/init` or `copilot init` before large tasks unless target `.github/copilot-instructions.md` already contains the required command/runtime/entrypoint/module facts or explicit `unknown` gaps.
- Installed plugin state for each target project must be stored in that target repository's `memories/repo/**` and `spec/**`, not in the plugin package or plugin cache.
- Memory stores recovery state and verified decisions, not long logs or secrets.

## Open Questions

- Does current Copilot CLI accept the marketplace plugin source path `.` for a root-level plugin directory in `funky-eyes/best-copilot`?

## Useful Output Format

1. Conclusion
2. Evidence
3. Risks
4. Next steps
