# Codex Repository Entry

This file is the thin Codex adapter. `.github/**` is the single source of truth for Copilot and this repository's AI customization. Platform, system, and explicit user instructions have higher priority than repository files; when there is no conflict, read the entries below.

## Required Entries

1. `.github/instructions/must.instructions.md`: core rules, memory layers, prompt assembly, state contracts, language policy, and verification gates.
2. `.github/instructions/skills-index.instructions.md`: lightweight repo skill index.
3. `.github/copilot-instructions.md`: repository facts, build/test commands, and high-frequency conventions.
4. `memories/repo/INDEX.md` and `memories/repo/current-workstreams.md`: task memory routing and progress recovery.
5. `spec/INDEX.md`: active spec routing.

## Codex Conventions

- Before non-trivial repository tasks, read the relevant parts of `.github/copilot-instructions.md` and `.github/instructions/must.instructions.md`.
- When choosing a skill, read `.github/instructions/skills-index.instructions.md` first, then open only the selected skill. Do not bulk-read `.github/skills`.
- When resuming multi-step work, progressively read `memories/repo/INDEX.md -> current-workstreams.md -> linked_spec/linked_memory`.
- Edit canonical rules through `.github/**`; `.codex/skills`, `.codex/instructions`, and `.codex/prompts` are symlink bridges.
- Do not commit or run destructive commands unless explicitly requested.
- Detect the user's primary language and answer in that language unless the user asks otherwise.

## Runtime Adapter

| Copilot Capability | Codex Mapping | Boundary |
| --- | --- | --- |
| agent / handoff | `spawn_agent` + `wait_agent` / `send_input` | Use only when the user explicitly asks for agents, delegation, or parallel agent work. |
| read / search | `rg`, `sed`, `find`, `git diff`, and other read-only commands | Prefer explicit user paths and index hits; avoid unbounded scanning. |
| edit | Top-level Codex uses `apply_patch` | `.github/**`, `AGENTS.md`, and `memories/repo/**` are handled inline by the top-level session. |
| execute | `exec_command` | Real command evidence must include command and result. |
| todo | `update_plan` | Session plan only; does not replace formal spec/task state. |
