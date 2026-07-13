# Inline Fallback Templates Reference

Canonical templates for `repo-init-manual-fallback` when the shell helper and bootstrap skills are unavailable. Do NOT improvise content.

## `best-copilot.md` (canonical sentinel)

```md
---
version: "0.7.1"
---
```

Only the 3-line YAML frontmatter. No headings, descriptions, or dates.

## `.github/instructions/project.instructions.md`

PM MUST analyze the repo to fill fields. `<ANALYZE: ...>` are instructions, not content. Max 3 "unknown" values for detectable fields.

```md
---
name: target-project-facts
description: Repository facts, build/test commands, entrypoints, module boundaries.
applyTo: "**"
---
# Target Repository Facts
## Project Facts
- Project name: <ANALYZE: read directory name and README>
- Purpose: <ANALYZE: read README heading>
- Primary languages/frameworks: <ANALYZE: detect from build files, deps>
- Package/build system: <ANALYZE: Maven/Gradle/npm/go/pip>
- Bounded evidence files: <ANALYZE: list build files found>
## Build and Test Commands
| Purpose | Command | Notes |
| --- | --- | --- |
| Install deps | <ANALYZE: e.g. mvn install -DskipTests> | Inferred |
| Run tests | <ANALYZE: e.g. mvn test> | Inferred |
| Lint/checks | <ANALYZE: e.g. mvn verify> | Inferred |
| Start dev | <ANALYZE: e.g. mvn spring-boot:run> | Inferred |
## Runtime and Entry Points
- Application entrypoints: <ANALYZE: @SpringBootApplication, main()>
- Test entrypoints: <ANALYZE: src/test directories>
- Local runtime requirements: <ANALYZE: application.yml, Docker>
## Module Boundaries
- Source modules: <ANALYZE: pom.xml modules or build.gradle subprojects>
- Public API surfaces: <ANALYZE: @RestController, routes>
- Data/schema ownership: <ANALYZE: SQL, migrations, entities>
- UI ownership: <ANALYZE: frontend dirs, static resources>
- Security/auth ownership: <ANALYZE: *Security*, *Auth*, *OAuth*>
## Known Unknowns
<ANALYZE: only things undetectable without running the app>
## Verification Notes
- Init source: manual_fallback / Last verified: <timestamp>
## Init Status
- Init ready: no / Verified: no / Bootstrap contract version: 0.7.1
- Last full verification: pending / Reentry: best-copilot-version-sentinel-first
```

## `CLAUDE.md`

```md
# Claude Code Project Entry
## Best Copilot Instruction Imports
The standalone `@path` lines below are Claude Code import directives. Keep them unindented and outside code fences so Claude Code loads these target-local best-copilot instruction files into project context.

@.github/instructions/project.instructions.md
@.github/instructions/must.instructions.md
@.github/instructions/skills-index.instructions.md
## Claude Code Runtime
- Imported `.github/instructions/**` are the shared source for repository facts, workflow gates, and skill routing. System/platform/user instructions outrank imported files.
- Default agent: `"agent": "senior-project-expert"` in `.claude/settings.json`. PM dispatches to specialist subagents with scoped names (`best-copilot:technical-architect`, etc.).
- Plugin skills: namespaced slash commands such as `/best-copilot:repo-init-gate`. In shell-capable Claude Code, prefer the bundled preflight helper when discoverable. `Skill(...) Successfully loaded` is not completion evidence. Continue only after the preflight/scan path reports ready.
- Code intelligence is optional and capability-aware. Use exposed `codebase-memory-mcp` graph tools first, then `mcp__gitnexus__*`, `mcp__codegraph__*`, language-server tooling, and built-in Read/Grep/Glob plus shell `rg`; use the selected provider for symbol context, call-chain tracing, impact, and review scope, and record missing chain evidence when native search is the fallback.
- Keep this file short. Facts → `.github/instructions/`, memory → `memories/repo/**`, specs → `spec/**`.
```

## Codex Runtime Adapter

Create these files only when Codex compatibility is required.

### `AGENTS.md`

```md
# Codex Repository Entry

This file is the Codex adapter for the target repository. `.github/**` is the shared source of repository AI rules when it exists. System, platform, and explicit user instructions have higher priority than repository files.

## Required Entries

1. `.github/instructions/project.instructions.md`
2. `.github/instructions/must.instructions.md`
3. `.github/instructions/skills-index.instructions.md`
4. `memories/repo/INDEX.md` and `memories/repo/current-workstreams.md`
5. `spec/INDEX.md`
6. `.codex/agents/*.toml` when Codex custom-agent compatibility is required

## Runtime Rules

- Before non-trivial work, read relevant project and must instructions.
- When resuming multi-step work, read memory index, current workstreams, then linked spec/memory shards.
- Use `.agents/skills` or installed plugin skills for workflow skills; use `.codex/agents/*.toml` for Codex custom agents.
- When the user invokes best-copilot/Senior workflow from the default Codex session, the top-level Codex agent acts as Senior Project Expert: freeze the PM packet, assign owner/reviewer lanes during SDD, and dispatch Codex subagents only when multi-agent tooling is available and explicitly requested by the user or PM workflow.
- If Codex subagents are unavailable or disabled, state `HARNESS_DEGRADED codex_multi_agent_unavailable` for workflows that require parallel specialists; do not present a sequential fallback as equivalent to full subagent-driven development.
- Do not treat plugin package state as active project state.
- Task progress changes must update `tasks.md` and `memories/repo/current-workstreams.md`.
- Detect the user's primary language and answer in that language unless asked otherwise.
```

### `.codex/agents/*.toml`

Create all eight files with these exact `name` fields and include `description`, `nickname_candidates`, and `developer_instructions` in each file:

- `.codex/agents/senior-project-expert.toml`: `name = "senior-project-expert"`
- `.codex/agents/technical-architect.toml`: `name = "technical-architect"`
- `.codex/agents/developer.toml`: `name = "developer"`
- `.codex/agents/frontend-designer.toml`: `name = "frontend-designer"`
- `.codex/agents/quality-assurance-expert.toml`: `name = "quality-assurance-expert"`
- `.codex/agents/security-reviewer.toml`: `name = "security-reviewer"`
- `.codex/agents/specification-writer.toml`: `name = "specification-writer"`
- `.codex/agents/root-cause-fixer.toml`: `name = "root-cause-fixer"`

When the shell helper is unavailable, copy the role descriptions and `developer_instructions` from the deterministic helper in `repo-init-manual-fallback/scripts/bootstrap-target-scaffold.sh`; do not invent new role behavior.

## Memories Templates

All memory files use YAML frontmatter: `---\nid: <name>\ntype: <type>\nupdated_at: unknown\nstatus: initialized\ntags: [<tags>]\n---`

### `memories/repo/current-workstreams.md`

```md
---
id: current-workstreams
type: active-state
updated_at: unknown
status: initialized
load_tier: task-active
tags: [resume, progress, active-spec]
---

# Current Workstreams
## Active Topics / Closed Topics
- None yet. (repeat for each)
```

### `memories/repo/project-state.md`

```md
---
id: project-state
type: project-memory
updated_at: unknown
status: initialized
tags: [project, state, constraints]
---

# Project State
## One-line Summary: unknown
## Current State
- Current focus: unknown / Key acceptance signals: unknown / Current risk: unknown
```

### `memories/repo/workflow-rules.md`

```md
---
id: workflow-rules
type: repo-memory
updated_at: unknown
status: initialized
tags: [workflow, memory, spec]
---

# Workflow Rules
Memory never overrides current repo files, command output, system instructions, or explicit user instructions. Spec remains authoritative for requirements, design, and task acceptance.
```

### `memories/repo/decisions.md`

```md
---
id: decisions
type: decision-memory
updated_at: unknown
status: initialized
tags: [decisions, deprecated]
---

# Decisions
## Active / Deprecated Decisions
- None yet. (repeat for each)
```

### `memories/repo/INDEX.md`

```md
# Repo Memory Index
| File | Load tier | Tags | Use for | Linked spec | summary |
| --- | --- | --- | --- | --- | --- |
| `current-workstreams.md` | task-active | resume, progress | Resume work | `spec/INDEX.md` | Active workstream |
| `project-state.md` | task-reference | project, status | Current state | `spec/INDEX.md` | Project state |
| `workflow-rules.md` | task-reference | workflow, memory | Memory rules | `spec/INDEX.md` | Workflow rules |
| `decisions.md` | task-reference | decisions | Decisions | `spec/INDEX.md` | Decisions |
| `logs/README.md` | archive-reference | logs | Compressed logs | none | Archive |
| `archive/deprecated-decisions.md` | archive-reference | archive | Historical | none | Deprecated |
```

### `memories/README.md`

```md
# Repository Memory
Stores target-local AI memory. Does not override current repo files, command output, or user instructions.
## Layout
- `repo/INDEX.md`: routing table / `repo/current-workstreams.md`: active work
- `repo/project-state.md`: state / `repo/workflow-rules.md`: rules / `repo/decisions.md`: decisions
- `repo/logs/`: compressed logs / `repo/archive/`: deprecated
```

### `memories/repo/logs/README.md` — Store compressed task logs. No secrets/tokens/PII/transcripts.

### `memories/repo/archive/deprecated-decisions.md` — `# Deprecated Decisions` + `## Entries` + `- None yet.`

## Spec Templates

### `spec/INDEX.md`

```md
# Spec Index
| Directory | Tags | Status | Summary |
| --- | --- | --- | --- |
| `spec/templates/` | template | template | Reusable templates |
Maintenance: every MEDIUM/LARGE feature gets a spec directory with requirements.md, design.md, and tasks.md. Single-file SDD/design/plan notes are evidence only.
```

### `spec/templates/requirements-template.md`

```md
# Requirements
- Status: `draft | reviewed | approved | closed` / Linked: `design.md`, `tasks.md`
## Background / Current System Evidence / Goals / Non-Goals / Functional Requirements (FR table) / Data+API+Security+Compatibility / Acceptance Criteria / Traceability Matrix
```

### `spec/templates/design-template.md`

```md
# Design
- Status: `draft | reviewed | approved | implemented | closed` / Source: `requirements.md`
## Overview (Problem + Approach) / Current System Evidence / Design Decisions (DD table) / Proposed Changes / API+Data+Config Contracts / Error+Security+Release Risk / Verification Plan
```

### `spec/templates/tasks-template.md`

```md
# Tasks
Each task: requirement refs, design refs, owner lane, reviewer lanes, files, write set, read-before-write targets, dependencies, parallel group, parallel ready, acceptance checks, TDD/minimal check, verification command, ready artifacts, stop conditions. Keep tasks small enough for a fresh-context specialist to understand in 2-5 minutes; split mixed owner lanes or unrelated write sets before implementation.
```

## `must.instructions.md` and `skills-index.instructions.md`

These are large templates. When the shell helper is unavailable, read `target-instructions-bootstrap/SKILL.md` for the full templates.
