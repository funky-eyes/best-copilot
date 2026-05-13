# best-copilot Project Instructions

This file keeps project-level facts, build entrypoints, and high-frequency conventions only. General workflow rules, state contracts, memory budgets, and verification gates live in `.github/instructions/must.instructions.md`. Skill discovery starts from `.github/instructions/skills-index.instructions.md`.

## Project Positioning

- Project name: `best-copilot`
- Purpose: installable Copilot CLI agent-team plugin plus reusable Copilot/Codex repository customization template.
- Primary install surface: root `plugin.json`, installed with `copilot plugin install`.
- Canonical customization source: `.github/**`.
- Codex bridge: `AGENTS.md`, `.codex/agents/*.toml`, and `.codex/{instructions,prompts,skills}` symlinks.

## First Repository Initialization

- Before first use in a new repository, prefer Copilot's official `/init` or `copilot init`.
- Initialization output should write or update the target repository's `.github/copilot-instructions.md`.
- If placeholders remain, use `repo-init-scan` for bounded repository scanning before large tasks.

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
- Substantial tasks start with `Senior Project Expert`, then route to specialists.
- New features and bug fixes should add tests or minimal reproducible checks when practical.
- Public APIs, message formats, database schema, auth boundaries, dependencies, and CI/CD require blast-radius assessment first.
- Do not write secrets, tokens, credentials, PII, raw long logs, or internal hosts into instructions, memory, spec, or README.
- "Done", "passed", and "verified" require fresh command output, static checks, browser evidence, or replayable evidence.
- Detect the user's primary language before responding. Pasted logs, code, stack traces, or API responses do not override the language used for the actual request.

## Memory and Spec

- `memories/repo/INDEX.md` is a task-memory routing table, not a directory listing.
- `memories/repo/current-workstreams.md` is the first recovery entry after a session switch.
- `spec/INDEX.md` is the spec routing entry; MEDIUM/LARGE tasks use `requirements.md`, `design.md`, and `tasks.md` as authoritative specs.
- Memory records stable preferences, current state, verified decisions, and recovery entries only. It does not store chat transcripts, long logs, secrets, PII, or unverified guesses.
