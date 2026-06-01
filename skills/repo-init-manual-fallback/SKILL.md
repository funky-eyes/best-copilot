---
name: repo-init-manual-fallback
description: "Use inside repo-init-scan after the official stage whenever scaffold verification, bounded repair, or `best-copilot.md` rewrite is still needed."
---

# Repo Init Manual Fallback

Use this stage inside `repo-init-scan` whenever scaffold verification, bounded repair, or `best-copilot.md` rewrite is still needed. After official init succeeds, this stage still owns the final scaffold verification barrier and sentinel rewrite.

## Immediate Execution Rule

When this stage has just been loaded inside `repo-init-scan`, the next assistant action must create/repair/verify the required init artifacts or return `BLOCKED`, then emit `## Repo Init Manual Fallback`. Do not stop at `Skill(...repo-init-manual-fallback...) Successfully loaded`, and do not inspect business source except the bounded evidence allowed below.

## Boundary

- This stage is fail-closed. Do not continue to requirements analysis, planning, dependency/framework changes, security rewrites, or implementation until the required files have been created or a `BLOCKED` result has been returned.
- Reading package/build files is allowed only as bounded evidence for creating `.github/instructions/project.instructions.md`.
- Write persistent state into the target repository, never into the plugin installation/cache directory.
- Loading this skill or the bootstrap skills is not enough. Success requires actual create/repair operations in the target repository followed by path and content checks on disk.
- In shell-capable runtimes, first run the bundled deterministic helper when its path is discoverable from `CLAUDE_SKILL_DIR`, the active plugin directory, or the current skill directory. Treat the helper's `verified_paths` / `missing_paths` output as the primary evidence. If the helper cannot be located, perform the documented create-or-repair fallback inline instead of blocking solely on helper discovery.
- If `target-instructions-bootstrap`, `target-memory-bootstrap`, or `target-spec-bootstrap` cannot be invoked mechanically, read their `SKILL.md` templates and perform the documented create-only repair inline. Do not skip a missing scaffold because skill invocation was unavailable.
- Do not hand-write improvised versions of scaffold files. When creating files inline (no shell helper), use the exact template content from the `## Required First-Use Artifacts` and template sections of this skill. When a template is not present in this skill, read the corresponding `target-instructions-bootstrap`, `target-memory-bootstrap`, or `target-spec-bootstrap` skill for the full template before writing.
- The `best-copilot.md` sentinel must be written ONLY after all other 16 required artifacts exist and pass content verification. Writing `best-copilot.md` before other scaffolds are verified is a protocol violation.

## Sentinel Ownership

This skill owns constructing target-root `best-copilot.md`. The companion `repo-init-gate` skill owns validating it, and `repo-init-scan` owns orchestrating when this stage may write it. Do not define the sentinel format in the plugin repository's own `.github/instructions/project.instructions.md`; that file is only project-level guidance for developing this plugin.

## Required First-Use Artifacts

Before `next_task_ready: yes`, verify these paths in the target repository:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `CLAUDE.md` when the active target runtime is Claude Code or the user requests Claude Code compatibility.
- `memories/README.md`
- `memories/repo/INDEX.md`
- `memories/repo/current-workstreams.md`
- `memories/repo/project-state.md`
- `memories/repo/workflow-rules.md`
- `memories/repo/decisions.md`
- `memories/repo/logs/README.md`
- `memories/repo/archive/deprecated-decisions.md`
- `spec/INDEX.md`
- `spec/templates/requirements-template.md`
- `spec/templates/design-template.md`
- `spec/templates/tasks-template.md`

`best-copilot.md` is not a neutral scaffold. It is the verified-init sentinel for contract version `0.6.0` and must be written only after the other required artifacts and content checks pass.

Never write project descriptions, task summaries, or markdown headings into `best-copilot.md`. A file like `# Best Copilot Sentinel` plus a project summary is invalid, even if it mentions the right version. The only valid sentinel content is the exact frontmatter block shown below.

## Required Content Checks

- `.github/instructions/must.instructions.md` contains `## Request Flow`, `## Per-Request Hard Gates`, `### PM Native Ask Trigger Gate`, `## Shared State Contracts`, `## Search Precision`, `## Command Output Budget`, `## Memory And Spec`, `## Agents and Dispatch`, and `## Implementation and Verification`.
- That same file contains the specialist ask boundary plus `NEEDS_USER_INPUT` / `BLOCKED` fallback rule, `work_mode`, `task_type`, `pm_action`, fixed-string-before-regex search, VS Code `vscode_askQuestions` exact-tool priority, and the first-use scaffold gate.
- `.github/instructions/skills-index.instructions.md` contains bootstrap routing and the `## Claude Code Skill Names` guidance.
- When Claude Code compatibility is required, `CLAUDE.md` references `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, and `.github/instructions/skills-index.instructions.md`.

## Inline Fallback Templates

When the shell helper and bootstrap skills are unavailable, use these exact templates to create missing files. Do NOT improvise content — these templates are the canonical fallback.

### `best-copilot.md` (exact sentinel — no other content is valid)

```md
---
version: "0.6.0"
---
```

This file must contain ONLY the 3-line YAML frontmatter block above. Do not add headings, project names, descriptions, or dates.

### `CLAUDE.md` (Claude Code compatibility)

```md
# Claude Code Project Entry

@.github/instructions/project.instructions.md
@.github/instructions/must.instructions.md
@.github/instructions/skills-index.instructions.md

## Claude Code Runtime

- This file is the Claude Code adapter for the target repository. The imported `.github/instructions/**` files remain the shared source for repository facts, workflow gates, and skill routing.
- System, platform, and explicit user instructions outrank imported repository files.
- The default agent is set in `.claude/settings.json` as `"agent": "senior-project-expert"`, which makes the PM coordinator the main session entry point. You can also start explicitly with `claude --agent senior-project-expert`; if Claude reports a name collision, use `claude --agent best-copilot:senior-project-expert`.
- The PM coordinator dispatches work to specialist subagents via the Agent tool. Plugin specialists appear in `/agents` with scoped names such as `best-copilot:technical-architect`, `best-copilot:developer`, `best-copilot:frontend-designer`, `best-copilot:quality-assurance-expert`, `best-copilot:security-reviewer`, `best-copilot:specification-writer`, and `best-copilot:root-cause-fixer`; use the exact displayed name for dispatch or manual `@` mention.
- Background execution is a PM dispatch choice for independent read-only research/review with pre-granted permissions. Implementation, fixes, spec/memory writes, and permission-gated verification run foreground by default.
- Isolated worktree implementation must return worktree path, branch, changed files, and verification evidence to PM; PM performs keep / merge / PR / discard closeout before claiming the change landed.
- Use plugin skills as namespaced slash commands such as `/best-copilot:repo-init-gate`, `/best-copilot:structured-review`, `/best-copilot:verification-before-completion`, unless the picker inserts another displayed plugin form. These plugin skills are distinct from Claude Code's bare built-in `/init` command.
- A `Skill(...) Successfully loaded` line only confirms instruction loading. The first-use init gate is complete only after `repo-init-scan` verifies target-local files on disk and reports `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.
- For `repo-init-gate`, the next observable action after the skill load must be reading only target-root `best-copilot.md` and emitting `## Repo Init Gate`. If the transcript shows `Skill(best-copilot:repo-init-gate) Successfully loaded` followed by search/read/codegraph/project-structure exploration before that block, stop using that premature context and run the gate inline immediately.
- For `repo-init-scan`, the next observable action after the skill load must be staged init work or `BLOCKED`, ending in `## Init Summary`. Search/read/codegraph/project-structure exploration before that summary is invalid.
- Do not synthesize init success from text. If file read/write or disk verification cannot actually run, return `BLOCKED tool_execution_unavailable`; a prose-only `## Init Summary` without required yes/no fields, every path from `repo-init-scan` Required Artifact Set, and `missing_paths: none` is invalid.
- The PM coordinator must not inspect business source with codegraph/read/search before init completes. For standard or full work after init, PM dispatches named specialists for business-code inspection and fans in their structured evidence.
- Codegraph MCP is optional. If `mcp__codegraph__*` tools are absent or failed in the current session, use built-in Read/Grep/Glob plus shell `rg`; if present, prefer codegraph for structural discovery.
- Keep this file short. Add project facts to `.github/instructions/project.instructions.md`, durable recovery state to `memories/repo/**`, and task specs to `spec/**`.
```

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

## Routing

- Load when: resuming work, checking current progress, or deciding next action.
- Pair with: `spec/INDEX.md`, the selected `linked_spec`, and the selected `linked_memory`.
- Skip when: the task is a one-off question unrelated to active project state.

## Active Topics

- None yet.

## Closed Topics

- None yet.
```

### `memories/repo/project-state.md`

```md
---
id: project-state
type: project-memory
updated_at: unknown
status: initialized
priority: medium
tags: [project, state, constraints]
---

# Project State

## One-line Summary

unknown

## Current State

- Current focus: unknown
- Key acceptance signals: unknown
- Current risk: unknown

## Constraints

- Memory stores recovery state and verified decisions, not long logs or secrets.

## Open Questions

- None recorded.
```

### `memories/repo/workflow-rules.md`

```md
---
id: workflow-rules
type: repo-memory
updated_at: unknown
status: initialized
priority: high
tags: [workflow, memory, prompt, spec, token-budget]
---

# Workflow Rules

## One-line Summary

Use Markdown-based memory routing and stable-prefix prompt assembly to keep context small while preserving current progress.

## Current State

- Memory is split into active state, task reference, and archive/logs.
- `INDEX.md` routes by tags, use_for, load_tier, and linked_spec.
- `current-workstreams.md` stores current focus, next resume action, last verified evidence, and links to spec/memory.
- Memory retrieval follows progressive disclosure: index first, current state second, exact shard only when needed.

## Constraints

- Memory never overrides current repo files, command output, system instructions, or explicit user instructions.
- Spec remains the authoritative source for requirements, design, and task acceptance.
- Memory stores status, decisions, recovery hints, and verified learnings only.
- Exclude secrets, tokens, private logs, and PII from durable memory.
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

## Active Decisions

- None yet.

## Deprecated Decisions

- None yet.

## Decision Update Rule

When a decision changes, add a new dated entry and mark the old entry deprecated with the replacement decision.
```

### `memories/repo/INDEX.md`

```md
# Repo Memory Index

<!-- markdownlint-disable MD013 -->

## Retrieval Order

1. Read this index.
2. If resuming active work, read `current-workstreams.md`.
3. Follow `linked_spec` and `linked_memory`.
4. Load only the relevant section from the selected memory file.
5. Fall back to archive/logs only when source tracing is required.

## Routing Table

| File | Load tier | Tags | Use for | Linked spec | Last updated | One-line summary |
| --- | --- | --- | --- | --- | --- | --- |
| `current-workstreams.md` | task-active | resume, progress, active-spec | Resume current work and find next action | `spec/INDEX.md` | unknown | Active workstream summary |
| `project-state.md` | task-reference | project, status, constraints | Current project state and important constraints | `spec/INDEX.md` | unknown | Compact project state |
| `workflow-rules.md` | task-reference | workflow, prompt, memory, spec | Memory retrieval, prompt assembly, and spec-memory coordination rules | `spec/INDEX.md` | unknown | Memory workflow rules |
| `decisions.md` | task-reference | decisions, deprecated | Durable decisions and superseded decisions | `spec/INDEX.md` | unknown | Date-stamped decisions |
| `logs/README.md` | archive-reference | logs, recovery | Compressed logs loaded only on demand | none | unknown | Archive area for compressed logs |
| `archive/deprecated-decisions.md` | archive-reference | archive, deprecated | Historical decisions that should not guide new work by default | none | unknown | Deprecated decisions and replacement links |

## Maintenance Rules

- Every new repo memory file must get one routing row here.
- Update `last_updated` and the one-line summary when a memory file changes.
- Do not paste long logs into this index.
- If a file grows beyond 200 lines or mixes topics, split it and update this table.
```

### `memories/README.md`

```md
# Repository Memory

This directory stores target-local AI memory for this repository.

Memory helps future sessions resume verified work without rereading every file. It does not override current repository files, command output, system instructions, or explicit user instructions.

## Layout

- `repo/INDEX.md`: routing table.
- `repo/current-workstreams.md`: active work and next resume action.
- `repo/project-state.md`: compact current state and constraints.
- `repo/workflow-rules.md`: memory/spec coordination rules.
- `repo/decisions.md`: durable dated decisions.
- `repo/logs/`: compressed logs loaded only on demand.
- `repo/archive/`: deprecated or historical memory.
```

### `memories/repo/logs/README.md`

```md
# Memory Logs

Store compressed, task-specific logs only when they are needed for future recovery.

- Prefer summaries and command evidence over raw logs.
- Do not store secrets, tokens, private data, or full chat transcripts.
- Link important log summaries from `memories/repo/INDEX.md` when they become retrieval-worthy.
```

### `memories/repo/archive/deprecated-decisions.md`

```md
# Deprecated Decisions

Historical decisions live here only after they have been replaced or should no longer guide new work by default.

## Entries

- None yet.
```

### `spec/INDEX.md`

```md
# Spec Index

<!-- markdownlint-disable MD013 -->

| Directory | Tags | Last updated | Status | Linked memory | Summary |
| --- | --- | --- | --- | --- | --- |
| `spec/templates/` | template, requirements, design, tasks | unknown | template | `memories/repo/workflow-rules.md` | Reusable templates for new spec bundles |

## Maintenance Rules

- Every MEDIUM/LARGE feature gets a spec directory with `requirements.md`, `design.md`, and `tasks.md`.
- Add a row here when creating a spec.
- Link active specs back to `memories/repo/current-workstreams.md`.
- Mark specs `closed` when the workstream is complete and memory has been compressed.
- Do not store secrets, raw private logs, or broad chat transcripts in specs.
```

### `spec/templates/requirements-template.md`

```md
# Requirements

## Metadata

- Status: `draft | reviewed | approved | closed`
- Owner lane: `senior-project-expert | specification-writer | technical-architect | developer | frontend-designer`
- Linked design: `design.md`
- Linked tasks: `tasks.md`
- Linked memory: `memories/repo/current-workstreams.md`, `<topic memory>`
- Last updated: `<YYYY-MM-DD>`

## Background

Describe the problem in observable terms, not as a desired implementation.

- Current behavior: `<what the system does now, with source references>`
- Trigger: `<user request, incident, roadmap item, audit finding, or repeated workflow failure>`
- Affected users or systems: `<actors, clients, jobs, APIs, or runtime surfaces>`
- Why now: `<risk, deadline, compatibility need, or quality gap>`

## Goals

- `<user-visible or operational outcome>`

## Non-Goals

- `<explicitly excluded behavior, migration, UI, API, dependency, or refactor>`

## Functional Requirements

| ID | Requirement | Priority | Source | Acceptance Signal | Task Refs |
| --- | --- | --- | --- | --- | --- |
| FR-001 | `<The system must ...>` | `P0 | P1 | P2` | `<evidence or user source>` | `<check>` | `<fill after tasks.md>` |

## Acceptance Criteria

- `<AC-001: concrete observable check mapped to FR IDs>`
```

### `spec/templates/design-template.md`

```md
# Design

## Metadata

- Status: `draft | reviewed | approved | implemented | closed`
- Requirement source: `requirements.md`
- Task source: `tasks.md`
- Owner lane: `technical-architect | frontend-designer | developer | specification-writer`
- Review lanes: `<developer, qa, security, frontend, technical-architect>`
- Last updated: `<YYYY-MM-DD>`

## Overview

- Problem summary: `<one or two sentences>`
- Chosen approach: `<smallest design that satisfies the requirements>`
- Compatibility stance: `<unchanged behavior, migration, or breaking-change note>`
- Rollout stance: `<direct, staged, feature flag, or manual migration>`

## Proposed Changes

### Component and Ownership Map

| Surface | Change | Owner lane | Read-before-write targets |
| --- | --- | --- | --- |
| `<file/module/API>` | `<add/change/remove>` | `<lane>` | `<public surface, caller/callee, shared utility>` |

## Verification Plan

| Requirement | Test or check | Command or method | Owner lane |
| --- | --- | --- | --- |
| `<FR ID>` | `<unit/integration/static/browser/manual>` | `<command or evidence>` | `<lane>` |
```

### `spec/templates/tasks-template.md`

```md
# Tasks

## Execution Rules

- Every implementation task must map to at least one requirement ID and one design decision.
- Split by ownership boundary, dependency order, and non-overlapping write set; do not split by vague phases alone.
- Each task must include read-before-write targets, acceptance checks, verification, reviewer lanes, and stop conditions.
- If a task has unresolved product or security input that changes behavior, mark it blocked instead of guessing.

## Task List

### Task 1: `<short imperative title>`

- Requirement refs: `<FR-001, FR-002>`
- Design refs: `<DD-001>`
- Owner lane: `technical-architect | developer | frontend-designer | root-cause-fixer | specification-writer`
- Reviewer lanes: `<developer, technical-architect, qa, security, frontend>`
- Files involved: `<explicit files or surfaces>`
- Write set: `<files this task may edit>`
- Dependencies: `<none | Task IDs>`
- Parallel group: `<G0/G1/... or parallel_ready: false>`
- Acceptance checks:
  - `<observable result mapped to requirement refs>`
- Verification command:
  - `<command or manual evidence path>`
- Stop conditions:
  - `<failed verification, missing context, write-set conflict, scope expansion, security concern>`
```

## Steps

1. Start from the current `.github/instructions/project.instructions.md` when it already exists and passed the official-init success bar:
   - Reuse that file as the primary fact packet.
   - Scan only the missing fact categories, missing scaffold surfaces, or unresolved `unknown` gaps that still block verification.
2. Otherwise do a bounded manual scan:
   - Read `CLAUDE.md`, `.github/copilot-instructions.md`, or `AGENTS.md` first when `repo-init-official` created or updated one through a target-local `init` skill, Claude native `/init`, or Copilot `copilot init`; treat it as official initializer evidence, but still verify facts against repository files before recording them.
   - Read `README*`, package/build files, CI files, app entrypoints, test directories, and existing `.github/instructions/project.instructions.md`.
   - Search only for build/test/dev entrypoints and major module boundaries.
   - Record unresolved facts as `unknown` instead of guessing.
3. Create or repair `.github/instructions/project.instructions.md` with: `Project Facts`, `Build and Test Commands`, `Runtime and Entry Points`, `Module Boundaries`, `Known Unknowns`, `Verification Notes`, and `Init Status`.
4. Replace neutral scaffold markers with `Init source: manual_fallback|official_init_plus_manual_fallback` and a real verification timestamp or bounded-scan note.
5. Ensure `## Init Status` contains:
   - `Init ready: yes|no`
   - `Required artifacts verified: yes|no`
   - `Bootstrap contract version: 0.6.0`
   - `Last full verification: <timestamp-or-bounded-scan-note>`
   - `Reentry rule: best-copilot-version-sentinel-first`
6. Initialize missing target-local scaffolds in this order:
   - bundled `scripts/bootstrap-target-scaffold.sh` helper when shell access and the helper are available
   - `target-instructions-bootstrap`
   - `target-memory-bootstrap`
   - `target-spec-bootstrap`
   Loading those skills only makes their templates available; the caller must still create or repair the listed target files before continuing.
7. Re-check the required artifact paths on disk.
8. Re-check the required instruction content.
9. After the other required artifacts and content checks pass, write the target root `best-copilot.md` exactly as:

```md
---
version: "0.6.0"
---
```

10. Verify:
   - `.github/instructions/project.instructions.md` exists and is not placeholder-heavy.
   - The `## Init Status` block contains `Bootstrap contract version: 0.6.0`.
   - The target root `best-copilot.md` exists and exactly matches the expected frontmatter sentinel.
   - Any bootstrap-created files exist on disk and did not overwrite project-specific content.
   - `verified_paths` covers every path under Required First-Use Artifacts, plus `best-copilot.md` after sentinel rewrite; otherwise report `missing_paths`, `required_artifacts_verified: no`, and `next_task_ready: no`.

## Output

```markdown
## Repo Init Manual Fallback
- status: success|blocked
- required_artifacts_verified: yes|no
- sentinel_written: yes|no
- next_task_ready: yes|no
- verified_paths: <every required artifact checked on disk, plus best-copilot.md>
- missing_paths: none|<paths not present or not content-valid>
```
