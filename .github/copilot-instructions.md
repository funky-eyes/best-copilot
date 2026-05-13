# best-copilot Project Instructions

This file keeps project-level facts, build entrypoints, and high-frequency conventions only. General workflow rules, state contracts, memory budgets, and verification gates live in `.github/instructions/must.instructions.md`. Skill discovery starts from `.github/instructions/skills-index.instructions.md`.

## Project Positioning

- Project name: `best-copilot`
- Purpose: installable Copilot CLI agent-team plugin plus reusable Copilot/Codex repository customization template.
- Primary install surface: `.github/plugin/marketplace.json`, registered with `copilot plugin marketplace add`, then installed with `copilot plugin install best-copilot@best-copilot`.
- Canonical customization source: `.github/**`.
- Codex bridge: `AGENTS.md`, `.codex/agents/*.toml`, and `.codex/{instructions,prompts,skills}` symlinks.

## First Repository Initialization

- Before first use in a new repository, prefer Copilot's official `/init` or `copilot init`.
- The plugin has no install-time or first-message hook that can force initialization before an agent is invoked. Treat initialization as the first-substantial-task gate instead.
- Judge init state from target repository files, not from chat history. If `.github/copilot-instructions.md` exists, has no unresolved init placeholders, and records build/test/check/dev command facts plus runtime/framework, entrypoint, and module-boundary facts or explicit `unknown` gaps, do not rerun init just because a new conversation started.
- If the active runtime can execute shell commands, run `copilot init` directly before requirements analysis. If only Copilot interactive slash commands are available, ask the user to run `/init`.
- Initialization output should write or update the target repository's `.github/copilot-instructions.md`.
- Normalize `/init` output into reusable repo facts: runtime/framework, build/test/dev commands, entrypoints, module boundaries, major ownership surfaces, and explicit `unknown` gaps instead of guesses.
- After initialization, continue the original user request in the same conversation whenever possible.
- If placeholders remain, use `repo-init-scan` for bounded repository scanning before large tasks.

## Target Repository State

- Plugin installation contributes agents and skills; it does not provide shared per-project memory storage.
- Store target project memory under that repository's `memories/repo/**`.
- Store target project specs under that repository's `spec/**`.
- The bundled `memories/` and `spec/` directories in this plugin are templates and plugin-repository state. Do not write another project's facts, workstreams, or specs into the plugin package or plugin cache.
- If a target repository lacks these directories and persistent recovery is needed, create the minimal skeleton locally in the target repository.

## Build and Verification

This is a Markdown configuration template, not an application build. Verification is mainly static structure and schema checks.

| Scenario | Command |
| --- | --- |
| List plugin skills | `find .github/skills -maxdepth 2 -name SKILL.md | sort` |
| Check Codex bridge | `readlink .codex/instructions .codex/prompts .codex/skills` |
| Check JSON manifest | `ruby -rjson -e 'JSON.parse(File.read("plugin.json")); puts "plugin.json ok"'` |
| Check YAML frontmatter | `ruby -ryaml -e 'Dir[".github/{agents,skills}/**/*.{md,agent.md}"].each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'` |
| Residual scan | `rg --hidden -n "legacy-template-name|project-specific-name|internal-host" .` |

## Implementation Conventions

- Repository-authoritative sources beat memory, chat history, and external references.
- External repositories, prompts, skills, and plugins are reference inputs only; absorb them as local routing, context, verification, and recovery primitives instead of copying them wholesale.
- Per-turn start timestamps and native closeout confirmation are hard requirements owned by `.github/instructions/must.instructions.md`; do not end a turn on prose alone.
- Substantial tasks start with `Senior Project Expert`, then route to specialists.
- New features and bug fixes should add tests or minimal reproducible checks when practical.
- Public APIs, message formats, database schema, auth boundaries, dependencies, and CI/CD require blast-radius assessment first.
- Frontend work should route through `Frontend Designer` and `frontend-design-guardrails`; prefer existing design systems and Ant Design-style enterprise patterns when present, freeze a small design-system packet before non-trivial UI work, and verify with browser evidence through `web-experience-audit`.
- Do not write secrets, tokens, credentials, PII, raw long logs, or internal hosts into instructions, memory, spec, or README.
- "Done", "passed", and "verified" require fresh command output, static checks, browser evidence, or replayable evidence.
- Detect the user's primary language before responding. Pasted logs, code, stack traces, or API responses do not override the language used for the actual request.

## Memory and Spec

- `memories/repo/INDEX.md` is a task-memory routing table, not a directory listing.
- `memories/repo/current-workstreams.md` is the first recovery entry after a session switch.
- `spec/INDEX.md` is the spec routing entry; MEDIUM/LARGE tasks use `requirements.md`, `design.md`, and `tasks.md` as authoritative specs.
- Memory records stable preferences, current state, verified decisions, and recovery entries only. It does not store chat transcripts, long logs, secrets, PII, or unverified guesses.
