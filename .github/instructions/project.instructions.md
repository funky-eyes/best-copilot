---
name: best-copilot-project
applyTo: "**"
description: Project facts, build entrypoints, target bootstrap policy, and high-frequency conventions for best-copilot.
---

# best-copilot Project Instructions

This file keeps project-level facts, build entrypoints, and high-frequency conventions only. General workflow rules, state contracts, memory budgets, and verification gates live in `.github/instructions/must.instructions.md`. Skill discovery starts from `.github/instructions/skills-index.instructions.md`.

## Project Positioning

- Project name: `best-copilot`
- Purpose: installable Copilot CLI and Claude Code agent-team plugin plus reusable repository workflow customization templates.
- Primary Copilot install surfaces: root `plugin.json` for direct repository install, and root `marketplace.json` for `copilot plugin marketplace add`.
- Primary Claude Code install surfaces: `.claude-plugin/marketplace.json` for `/plugin marketplace add`, plus `.claude-plugin/plugin.json` for local `claude --plugin-dir /path/to/best-copilot` development.
- Copilot discovery source: root `agents/` and `skills/`, declared by `plugin.json`.
- Claude Code discovery source: root `skills/` plus explicit root `claude-agents/*.agent.md` files declared by `.claude-plugin/plugin.json`.
- Repository instruction source: `.github/instructions/**`.
- Current compatibility targets: Copilot CLI plugin installation and Claude Code plugin loading. Codex compatibility is not a release target for this layout.
- Runtime adapter architecture: shared cross-role behavior lives in `skills/core-workflow-contract/SKILL.md`; role-specific workflow behavior lives in matching `skills/*-workflow/SKILL.md` files; Copilot-only model/tool/handoff metadata lives in `agents/*.agent.md`; Claude-only scoped subagent, model inheritance, and agent-team limitations live in matching `claude-agents/*.agent.md` files.
- Claude Code adapters preload only `core-workflow-contract` and their matching role workflow skill in frontmatter. Focused skills stay on-demand in the agent body to avoid unnecessary startup context.

## First Repository Initialization

- Before first use in a new repository, prefer the active runtime's official project initialization as evidence gathering only: `/init` in Copilot CLI, VS Code Copilot, or Claude Code when available; `copilot init` when the Copilot CLI command is available.
- The plugin has no install-time or first-message hook that can force initialization before an agent is invoked. Treat initialization as the first-substantial-task gate instead.
- This gate is fail-closed: if `.github/instructions/project.instructions.md` is missing or incomplete, do not proceed to requirements analysis, dependency/framework upgrades, security rewrites, or implementation. Only official init, bounded manual fact capture, and target bootstrap file creation are allowed.
- Judge init state from target repository files, not from chat history. If `.github/instructions/project.instructions.md` exists, has no unresolved init placeholders, is not the untouched neutral scaffold, and records build/test/check/dev command facts plus runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown` gaps, do not rerun init just because a new conversation started.
- Missing target-local instruction/memory/spec scaffolds are not a reason to rerun official init. If facts are current but scaffolds are absent, run only `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- If the active runtime can execute shell commands and `copilot init` is available, run it directly before requirements analysis when facts are missing, then normalize the useful output into `.github/instructions/project.instructions.md`. If only interactive slash commands are available, use `/init` in the current runtime, then normalize the resulting evidence into `.github/instructions/project.instructions.md`.
- Initialization output should be verified and normalized into the target repository's `.github/instructions/project.instructions.md`.
- After official init, verify that `.github/instructions/project.instructions.md` exists on disk. If the command produced output but no project facts file, treat it as `official_init_no_write` and use `repo-init-scan` manual fallback to create the file from bounded repository evidence.
- Normalize `/init` output into reusable repo facts: runtime/framework, build/test/dev commands, entrypoints, module boundaries, major ownership surfaces, and explicit `unknown` gaps instead of guesses.
- After repository facts exist, use bootstrap skills to create missing target-local scaffolds: `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- First-use scaffolds must be verified on disk before continuing: `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, `.github/instructions/skills-index.instructions.md`, `memories/README.md`, `memories/repo/INDEX.md`, `memories/repo/current-workstreams.md`, `memories/repo/project-state.md`, `memories/repo/workflow-rules.md`, `memories/repo/decisions.md`, `memories/repo/logs/README.md`, `memories/repo/archive/deprecated-decisions.md`, `spec/INDEX.md`, `spec/templates/requirements-template.md`, `spec/templates/design-template.md`, and `spec/templates/tasks-template.md`.
- If required facts or scaffolds cannot be created because tools, permissions, or target paths are unavailable, return `BLOCKED first_use_gate_incomplete` with the missing paths; do not continue the user's substantive task.
- After initialization, continue the original user request in the same conversation whenever possible.
- If placeholders remain, use `repo-init-scan` for bounded repository scanning before large tasks.

## Target Repository State

- Plugin installation contributes agents and skills; it does not provide shared per-project memory storage.
- Store target project facts under that repository's `.github/instructions/project.instructions.md`.
- Store target project memory under that repository's `memories/repo/**`.
- Store target project specs under that repository's `spec/**`.
- This plugin checkout does not keep active target-project instruction/memory/spec files. Installed projects get durable local files from `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, not by copying this plugin's root `agents/`, root `skills/`, `.github/instructions/**`, `memories/**`, or `spec/**`.
- If a target repository lacks local instructions, memory, or spec scaffolds and persistent recovery is needed, create the minimal skeleton locally in the target repository.

## Build and Verification

This is a Markdown configuration template, not an application build. Verification is mainly static structure and schema checks.

| Scenario | Command |
| --- | --- |
| List plugin skills | `find skills -maxdepth 3 -name SKILL.md | sort` |
| List plugin agents | `find agents -maxdepth 1 -name "*.agent.md" | sort` |
| List Claude Code agent adapters | `find claude-agents -maxdepth 1 -name "*.agent.md" | sort` |
| Check JSON manifest | `ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); puts "json ok"'` |
| Check marketplace catalog | `ruby -rjson -e 'JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "marketplace json ok"'` |
| Check YAML frontmatter | `ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'` |
| Residual scan | `rg --hidden -n "legacy-template-name|project-specific-name|internal-host" .` |

For local plugin development, reinstall or update the plugin after changing agents, skills, or instructions. Copilot CLI reads installed plugin components from its plugin cache, so an unreinstalled local checkout can make tests appear to ignore recent edits.
For Claude Code distribution, users should add the marketplace with `/plugin marketplace add funky-eyes/best-copilot`, install with `/plugin install best-copilot@best-copilot`, and run `/reload-plugins` after installation or updates. For local plugin development, start with `claude --plugin-dir /absolute/path/to/best-copilot` or run `/reload-plugins` after edits. Claude Code plugin agents use lowercase-hyphen frontmatter names from explicit `claude-agents/*.agent.md` files declared in `.claude-plugin/plugin.json`; filenames mirror root `agents/*.agent.md` for maintainability, while Copilot display names in `agents/*.agent.md` are not valid Claude Code agent identifiers.

## Implementation Conventions

- Repository-authoritative sources beat memory, chat history, and external references.
- External repositories, prompts, skills, and plugins are reference inputs only; absorb them as local routing, context, verification, and recovery primitives instead of copying them wholesale.
- Per-turn start timestamps and native closeout confirmation are hard requirements owned by `.github/instructions/must.instructions.md`; do not end a turn on prose alone.
- Blocking clarification, route selection, execution approval, continuation, and closeout must use native structured UI when available, but only from the top-level session, PM/coordinator, or a specialist directly invoked by the user: `ask_user` in Copilot CLI, or `vscode/askQuestions` / `askQuestions` / equivalent structured UI in VS Code. PM-delegated specialists return `NEEDS_USER_INPUT` to PM instead of asking the user directly. Plain prose questions do not count.
- When the user has already said to start development, safe non-destructive preparation such as creating an isolated worktree should proceed directly if the runtime permits it. Ask only for destructive, ambiguous, dirty-state, or user-owned-path choices, and ask natively.
- Substantial tasks start with `Senior Project Expert`, then route to specialists.
- MEDIUM/LARGE tasks must pass spec/design readiness review before implementation, then execute from an approved plan through `subagent-driven-development` or `executing-plans`; each task needs spec-compliance review, code-quality/release-risk review, and verification evidence before closure.
- New features and bug fixes should add tests or minimal reproducible checks when practical.
- Public APIs, message formats, database schema, auth boundaries, dependencies, and CI/CD require blast-radius assessment first.
- Frontend work should route through `Frontend Designer` and `frontend-design-guardrails`; prefer existing design systems and Ant Design-style enterprise patterns when present, freeze a small design-system packet before non-trivial UI work, and verify with browser evidence through `web-experience-audit`.
- Do not write secrets, tokens, credentials, PII, raw long logs, or internal hosts into instructions, memory, spec, or README.
- "Done", "passed", and "verified" require fresh command output, static checks, browser evidence, or replayable evidence.
- Why/how follow-ups, rule clarifications, solution comparisons, and review-response discussions are not closeout exemptions; if the answer would end the current batch, use native closeout before sending a final ending message.
- Detect the user's primary language before responding. Pasted logs, code, stack traces, or API responses do not override the language used for the actual request.

## Memory and Spec

- Installable memory and spec templates live in `target-memory-bootstrap` and `target-spec-bootstrap`.
- Target repositories that need persistent recovery should create their own `memories/repo/INDEX.md`, `current-workstreams.md`, and `spec/INDEX.md`.
- Target memory records stable preferences, current state, verified decisions, and recovery entries only. It does not store chat transcripts, long logs, secrets, PII, or unverified guesses.
