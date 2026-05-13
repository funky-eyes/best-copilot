---
id: decisions
type: decision-memory
updated_at: 2026-05-13
status: active
tags: [decisions, deprecated]
---

# Decisions

## Active Decisions

- 2026-05-11: Use indexed Markdown memory before considering vector RAG.
- 2026-05-11: Keep `.github/**` as the canonical source for agent, instruction, prompt, and skill definitions.
- 2026-05-11: Keep `.codex/**` as a thin runtime adapter that points back to `.github/**`.
- 2026-05-13: Rename the public template to `best-copilot` and add root `plugin.json` for Copilot CLI plugin installation.
- 2026-05-13: Keep the default skill set lean; move niche PDF, observability, retro, branch-finish, worktree, and extra reference workflows out of the default install.
- 2026-05-13: Use Copilot's official `/init` / `copilot init` as the first-use repository learning step, with `repo-init-scan` as the local workflow wrapper.
- 2026-05-13: Add `evolution-loop` as the bounded self-improvement mechanism; use EvolutionEvent records for accepted workflow changes.
- 2026-05-13: Add README acknowledgements for the upstream projects that influenced agent orchestration, skills, memory, fetch, UI/UX, review, simplification, and evolution design.
- 2026-05-13: Keep `README.md` as the default English README and provide localized `README.zh-CN.md`, `README.ko.md`, and `README.ja.md`; keep agent/instruction/prompt/skill customization files in English.

## Deprecated Decisions

- None.

## Decision Update Rule

When a decision changes, add a new dated entry and mark the old entry deprecated with the replacement decision.
