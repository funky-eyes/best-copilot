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

- Claude agents declare `skills:` in frontmatter — only `core-workflow-contract` + matching role workflow are preloaded. Senior Project Expert also preloads `repo-init-gate`; `repo-init-scan` is loaded only when the sentinel gate fails. In shell-capable Claude Code, the preferred failed-gate path is the bundled `repo-init-gate/scripts/run-preflight.sh` helper, which preserves the sentinel fast path and directly runs the scan bootstrap on failure.
- Focused skills (e.g., `structured-review`, `test-driven-development`) are on-demand via namespaced slash commands such as `/best-copilot:skill-name` when installed as a plugin.
- In agent teams, teammate `skills:` frontmatter is ignored — spawn prompts must name skills explicitly or the teammate returns `NEEDS_CONTEXT missing_required_skill`.
- A `Skill(...) Successfully loaded` line means Claude loaded instructions; it does not mean the workflow ran. Repo init is complete only after the target files are created or verified on disk and the preflight/scan path reports `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.

### Code Intelligence MCP (GitNexus / CodeGraph)

Structural code intelligence is optional. Choose by current tool inventory in this order: GitNexus (`mcp__gitnexus__*`), then CodeGraph (`mcp__codegraph__*`), then built-in Read/Grep/Glob plus shell `rg`. A local binary or plugin inventory entry is not enough, and absent tools must not be called.

### Init Gate (mandatory preflight)

Before any substantive target-repository work: `repo-init-gate` reads the target root `best-copilot.md` sentinel. If frontmatter `version: "0.6.0"` matches, skip `repo-init-scan`. Otherwise run the preflight/scan bootstrap path, which orchestrates official init (`/init` or `copilot init`), normalizes facts into `.github/instructions/project.instructions.md`, and bootstraps missing scaffolds. Work is fail-closed until init is verified.

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
- `best-copilot.md` — init sentinel (frontmatter `version: "0.6.0"`)

Bootstrap skills (`target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap`) create these scaffolds on first use.

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **best-copilot** (1135 symbols, 1144 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/best-copilot/context` | Codebase overview, check index freshness |
| `gitnexus://repo/best-copilot/clusters` | All functional areas |
| `gitnexus://repo/best-copilot/processes` | All execution flows |
| `gitnexus://repo/best-copilot/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
