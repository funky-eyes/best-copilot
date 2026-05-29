# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

`best-copilot` is a dual-runtime agent-team plugin for both Claude Code and GitHub Copilot CLI. It is not a compiled application — all artifacts are Markdown (agents, skills, instructions) and JSON (manifests). There is no build step, no test suite, and no linter beyond JSON/YAML validation.

## Validation Commands

| Check | Command |
|---|---|
| Validate all JSON manifests | `ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'` |
| Validate YAML frontmatter in all agents/skills | `ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'` |
| List skills | `find skills -maxdepth 3 -name SKILL.md \| sort` |
| List Copilot agents | `find agents -maxdepth 1 -name '*.agent.md' \| sort` |
| List Claude agents | `find claude-agents -maxdepth 1 -name '*.md' \| sort` |
| Verify Claude plugin inventory | `claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot` (should show 8 agents, 39 skills) |
| Check for leftover placeholders | `rg --hidden -n "legacy-template-name\|project-specific-name\|internal-host" .` |
| Whitespace issues | `git diff --check` |

## Architecture

### Dual-Runtime Adapter Pattern

The project serves two runtimes from shared sources using an adapter pattern:

- **Shared layer** — `skills/core-workflow-contract/SKILL.md`: cross-role contracts (source priority, dispatch packets, review/verification gates, memory/spec rules, closeout). Role-specific behavior lives in `skills/*-workflow/SKILL.md`.
- **Copilot CLI layer** — `agents/*.agent.md`: Copilot-specific metadata (model names, `user_invocable`, `agents`, `handoffs`). Skills loaded from root `skills/`.
- **Claude Code layer** — `claude-agents/*.md`: Claude-specific metadata (Claude model aliases `opus` / `sonnet` / `haiku`, agent-team rules, read-only restrictions). Skills exposed via `claude-plugin/skills -> ../skills` symlink. Agents via `claude-plugin/agents -> ../claude-agents` symlink.

Key rule: shared behavior stays in `skills/`, incompatible runtime metadata stays in `agents/` or `claude-agents/`. Never mix them.

### Reliability Gates

Shared behavior in `skills/core-workflow-contract/SKILL.md` and `.github/instructions/must.instructions.md` requires explicit assumptions/tradeoffs, the simplest viable approach, surgical diffs, read-before-write evidence for code edits, goal-driven verification, and done/verified/left checkpoints for multi-step work. Target bootstrap templates must carry the same gates.

### Agent Team (8 roles)

Senior Project Expert owns orchestration (intent, scope, dispatch, fan-in, closeout). Seven specialists own their domain: Technical Architect (SDD design, implementation), Developer (frozen slices), Frontend Designer (UI), Specification Writer (requirements/specs), Quality Assurance Expert (verification/merge readiness), Security Reviewer (auth/deps/release surface), Root Cause Fixer (failure triage).

### Skill Loading

- Claude agents declare `skills:` in frontmatter — only `core-workflow-contract` + matching role workflow are preloaded. Senior Project Expert also preloads `repo-init-gate` and `repo-init-scan`.
- Focused skills (e.g., `structured-review`, `test-driven-development`) are on-demand via namespaced slash commands such as `/best-copilot:skill-name` when installed as a plugin.
- In agent teams, teammate `skills:` frontmatter is ignored — spawn prompts must name skills explicitly or the teammate returns `NEEDS_CONTEXT missing_required_skill`.
- A `Skill(...) Successfully loaded` line means Claude loaded instructions; it does not mean the workflow ran. Repo init is complete only after the target files are created or verified on disk and `repo-init-scan` reports `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.

### Codegraph MCP

Codegraph is optional. Treat it as available only when Claude exposes `mcp__codegraph__*` tools in the current session; a local `codegraph` binary or plugin inventory entry is not enough by itself. If the MCP server is unavailable or the command is not installed, do not call it and do not block; use built-in Read/Grep/Glob plus shell `rg` fallback.

### Init Gate (mandatory preflight)

Before any substantive target-repository work: `repo-init-gate` reads the target root `best-copilot.md` sentinel. If frontmatter `version: "0.5.1"` matches, skip `repo-init-scan`. Otherwise run `repo-init-scan` which orchestrates official init (`/init` or `copilot init`), normalizes facts into `.github/instructions/project.instructions.md`, and bootstraps missing scaffolds. Work is fail-closed until init is verified.

## Editing Conventions

- Edit Copilot agents in `agents/*.agent.md`, Claude agents in `claude-agents/*.md`, shared skills in `skills/`.
- `.github/instructions/**` contains repo-level rules: `must.instructions.md` (core rules), `project.instructions.md` (project facts), `skills-index.instructions.md` (skill routing).
- After editing agents/skills/instructions, reinstall the plugin or run `/reload-plugins` in Claude Code before testing. Copilot CLI reads from its installed plugin cache.
- When `plugin.json` version changes, update the init contract version in `best-copilot.md`, all `repo-init-*` skills, and the `best-copilot.md` sample in `target-instructions-bootstrap/SKILL.md`.

## Target Repository Integration

When installed in another repository, persistent state goes to that target repo — never to this plugin package:
- `.github/instructions/project.instructions.md` — project facts
- `memories/repo/**` — persistent task recovery
- `spec/**` — requirements, design, tasks
- `best-copilot.md` — init sentinel (frontmatter `version: "0.5.1"`)

Bootstrap skills (`target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap`) create these scaffolds on first use.
