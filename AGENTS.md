# Repository Entry

This file is the local repository entry for this checkout. The plugin package supports Copilot CLI and Claude Code: Copilot installable agents live in root `agents/`, Claude Code agent adapters live in root `claude-agents/`, shared installable skills live in root `skills/`, role-specific workflow skills live in `skills/*-workflow/`, and repository instructions live in `.github/instructions/**`. Platform, system, and explicit user instructions have higher priority than repository files; when there is no conflict, read the entries below.

## Required Entries

1. `.github/instructions/must.instructions.md`: core rules, memory layers, prompt assembly, state contracts, language policy, and verification gates.
2. `.github/instructions/skills-index.instructions.md`: lightweight repo skill index.
3. `.github/instructions/project.instructions.md`: repository facts, build/test commands, and high-frequency conventions.
4. `skills/target-*-bootstrap/SKILL.md`: installable templates used to create target-local instructions, memory, and spec scaffolds after repo init.
5. `.claude-plugin/plugin.json` and `claude-agents/*.agent.md`: Claude Code plugin manifest and lowercase-hyphen subagent adapters.

## Local Conventions

- Before non-trivial repository tasks, read the relevant parts of `.github/instructions/project.instructions.md` and `.github/instructions/must.instructions.md`.
- When choosing a skill, read `.github/instructions/skills-index.instructions.md` first, then open only the selected skill under root `skills/`. Do not bulk-read `skills/`.
- When working in a target repository that has its own memory, progressively read that target repository's `memories/repo/INDEX.md -> current-workstreams.md -> linked_spec/linked_memory`.
- This plugin checkout does not keep active target-project `memories/**` or `spec/**`; installed projects should be initialized through the bootstrap skills.
- Edit Copilot installable agents through root `agents/`; edit Claude Code adapters through root `claude-agents/`; edit shared installable skills through root `skills/`; edit repository instructions through `.github/instructions/**`.
- Do not commit or run destructive commands unless explicitly requested.
- Detect the user's primary language and answer in that language unless the user asks otherwise.

## Runtime Adapter

| Copilot Capability | Local Mapping | Boundary |
| --- | --- | --- |
| agent / handoff | `spawn_agent` + `wait_agent` / `send_input` | Use only when the user explicitly asks for agents, delegation, or parallel agent work. |
| read / search | `rg`, `sed`, `find`, `git diff`, and other read-only commands | Prefer explicit user paths and index hits; avoid unbounded scanning. |
| edit | Top-level session uses `apply_patch` | `.github/instructions/**`, root `agents/`, root `skills/`, `AGENTS.md`, and bootstrap skill template changes are handled inline by the top-level session. |
| execute | `exec_command` | Real command evidence must include command and result. |
| todo | `update_plan` | Session plan only; does not replace formal spec/task state. |
| `vscode/askQuestions` / `askQuestions` / `Asking user` | Use the available native ask mechanism when present | Top-level session and PM/coordinator only; specialists must not invoke native ask and should return `NEEDS_USER_INPUT` to PM when present or `BLOCKED missing_top_level_question` otherwise. Plain prose questions cannot replace native confirmation gates. If native ask is unavailable, continue only with a single safe interpretation or report a blocked/partial state. |
