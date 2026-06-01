#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"
compatibility="${2:-claude}"
contract_version="0.6.0"

if [ ! -d "$target_dir" ]; then
  echo "status=invalid_target_dir"
  echo "target_dir=$target_dir"
  exit 64
fi

cd "$target_dir" || exit 64

created_paths=""
missing_paths=""
content_errors=""

write_missing() {
  rel_path="$1"
  mkdir -p "$(dirname "$rel_path")"
  if [ -e "$rel_path" ]; then
    cat >/dev/null
    return 0
  fi
  cat >"$rel_path"
  created_paths="${created_paths}${rel_path}
"
}

append_if_missing() {
  rel_path="$1"
  needle="$2"
  if [ ! -f "$rel_path" ]; then
    cat >/dev/null
    return 0
  fi
  if grep -Fq "$needle" "$rel_path"; then
    cat >/dev/null
    return 0
  fi
  {
    printf '\n'
    cat
  } >>"$rel_path"
}

check_file() {
  rel_path="$1"
  if [ ! -f "$rel_path" ]; then
    missing_paths="${missing_paths}${rel_path}
"
  fi
}

check_contains() {
  rel_path="$1"
  needle="$2"
  if [ ! -f "$rel_path" ] || ! grep -Fq "$needle" "$rel_path"; then
    content_errors="${content_errors}${rel_path} missing ${needle}
"
  fi
}

write_missing ".github/instructions/project.instructions.md" <<'EOF'
---
name: target-project-facts
description: Repository facts, build and test commands, entrypoints, and module boundaries for this repository.
applyTo: "**"
---

# Target Repository Facts

## Project Facts

- Project name: unknown
- Purpose: unknown
- Primary languages/frameworks: unknown
- Package/build system: unknown

## Build and Test Commands

| Purpose | Command | Notes |
| --- | --- | --- |
| Install dependencies | unknown | Bounded init helper did not infer this command. |
| Run tests | unknown | Bounded init helper did not infer this command. |
| Run lint/checks | unknown | Bounded init helper did not infer this command. |
| Start dev/runtime | unknown | Bounded init helper did not infer this command. |

## Runtime and Entry Points

- Application entrypoints: unknown
- Test entrypoints: unknown
- Local runtime requirements: unknown

## Module Boundaries

- Source modules: unknown
- Public API surfaces: unknown
- Data/schema ownership: unknown
- UI ownership: unknown
- Security/auth ownership: unknown

## Known Unknowns

- Bounded first-use bootstrap recorded unknowns instead of guessing.

## Verification Notes

- Init source: manual_fallback
- Last verified: bounded first-use bootstrap

## Init Status

- Init ready: yes
- Required artifacts verified: yes
- Bootstrap contract version: 0.6.0
- Last full verification: bounded first-use bootstrap
- Reentry rule: best-copilot-version-sentinel-first
EOF

append_if_missing ".github/instructions/project.instructions.md" "## Init Status" <<'EOF'
## Init Status

- Init ready: yes
- Required artifacts verified: yes
- Bootstrap contract version: 0.6.0
- Last full verification: bounded first-use bootstrap
- Reentry rule: best-copilot-version-sentinel-first
EOF

append_if_missing ".github/instructions/project.instructions.md" "Bootstrap contract version: 0.6.0" <<'EOF'
## Best Copilot Init Repair

- Bootstrap contract version: 0.6.0
- Last full verification: bounded first-use bootstrap
- Reentry rule: best-copilot-version-sentinel-first
EOF

write_missing ".github/instructions/must.instructions.md" <<'EOF'
---
name: target-repo-must
description: Core AI rules for this repository.
applyTo: "**"
---

# Target Repository AI Rules

## Priority

System, platform, and explicit user instructions outrank repository files. Current repository files and command output outrank memory, old specs, and external references.

## Request Flow

1. Parse literal request, real intent, and success criteria.
2. Before the first substantial action in a turn, record a per-request start timestamp. If that timestamp was missed, do not backfill a fake duration later.
3. Read explicit user paths and init artifacts first. If repository facts are incomplete, normalize official init output into `.github/instructions/project.instructions.md`; command output without a verified facts file is `official_init_no_write`.
4. Before editing, freeze a minimal packet with goal, scope, constraints, expected outcome, assumptions, tradeoffs, simpler option considered, acceptance checks, verification budget, `work_mode`, and `task_type`.
5. Search at most three rounds. Prefer explicit paths, filename/glob lookup, and fixed-string `rg -F` before regex.
6. Before completion, provide real verification evidence or state the blocker.

## Reliability Gates

- Think before coding, choose the simplest viable approach, keep changes surgical, read before writing, and checkpoint significant steps.

## Per-Request Hard Gates

### No Silent Closeout

- Do not end a turn with a prose-only summary when a native ask tool is available.
- In VS Code, use `vscode_askQuestions` before final closeout. In other runtimes, use the native ask mechanism when exposed.
- Specialists must not ask users directly. Missing human input becomes `NEEDS_USER_INPUT` to PM/coordinator, or `BLOCKED missing_top_level_question` when PM is absent.

### PM Native Ask Trigger Gate

- PM/coordinator uses native ask for blocking clarification, route choice, execution approval, specialist `NEEDS_USER_INPUT`, continuation, and closeout.
- A native ask prompt must allow a custom free-form answer path.

## Repository Truth

- Treat `.github/instructions/project.instructions.md` as the project fact source.
- Do not guess stack, module ownership, security boundaries, or build commands.

## Shared State Contracts

- `work_mode` is `micro | standard | full`.
- `task_type` is `implementation | design_review | verification | fix | spec`.
- `pm_action` is used only with `status=NEEDS_CONTEXT`; current value is `pm_clarify`.

### Fan-In Arbitration

- PM/coordinator adjudicates blockers, security/release risk, failed verification, acceptance mismatch, overlapping writes, and review findings before closure.

## Search Precision

- Start from explicit paths, changed files, project facts, `spec/INDEX.md`, and `memories/repo/INDEX.md`.
- Prefer exact filename/glob and fixed-string-before-regex search.

## Command Output Budget

- Cap broad command output by default, for example `COMMAND 2>&1 | head -c 4000`.

## Memory And Spec

- Persistent memory belongs under `memories/repo/**`; specs belong under `spec/**`.
- On first substantial plugin use, create missing scaffolds through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then verify paths on disk.
- Use progressive disclosure: read indexes first, then only relevant shards.

## Interaction

- Use the user's primary language unless they ask otherwise.

## Agents and Dispatch

- PM/coordinator owns intent, scope, dispatch, adjudication, closeout, and evolution signals.
- Delegated specialists return structured handbacks and route user questions through PM.

## Implementation and Verification

- Prefer existing patterns. Public APIs, schemas, auth, dependencies, and CI/CD require blast-radius assessment.
- Before claiming work is done, run the smallest useful verification or state why it could not run.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Request Flow" <<'EOF'
## Request Flow

1. Parse literal request, real intent, and success criteria.
2. Before editing, freeze a minimal packet with goal, scope, constraints, expected outcome, assumptions, tradeoffs, simpler option considered, acceptance checks, verification budget, `work_mode`, and `task_type`.
3. Search at most three rounds. Prefer explicit paths, filename/glob lookup, and fixed-string `rg -F` before regex.
4. Before completion, provide real verification evidence or state the blocker.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Per-Request Hard Gates" <<'EOF'
## Per-Request Hard Gates

### No Silent Closeout

- Do not end a turn with a prose-only summary when a native ask tool is available.
- Specialists must not ask users directly. Missing human input becomes `NEEDS_USER_INPUT` to PM/coordinator, or `BLOCKED missing_top_level_question` when PM is absent.

### PM Native Ask Trigger Gate

- PM/coordinator uses native ask for blocking clarification, route choice, execution approval, specialist `NEEDS_USER_INPUT`, continuation, and closeout.
- A native ask prompt must allow a custom free-form answer path.
EOF

append_if_missing ".github/instructions/must.instructions.md" "### PM Native Ask Trigger Gate" <<'EOF'
### PM Native Ask Trigger Gate

- PM/coordinator uses native ask for blocking clarification, route choice, execution approval, specialist `NEEDS_USER_INPUT`, continuation, and closeout.
- A native ask prompt must allow a custom free-form answer path.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Shared State Contracts" <<'EOF'
## Shared State Contracts

- `work_mode` is `micro | standard | full`.
- `task_type` is `implementation | design_review | verification | fix | spec`.
- `pm_action` is used only with `status=NEEDS_CONTEXT`; current value is `pm_clarify`.

### Fan-In Arbitration

- PM/coordinator adjudicates blockers, security/release risk, failed verification, acceptance mismatch, overlapping writes, and review findings before closure.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Search Precision" <<'EOF'
## Search Precision

- Start from explicit paths, changed files, project facts, `spec/INDEX.md`, and `memories/repo/INDEX.md`.
- Prefer exact filename/glob and fixed-string-before-regex search.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Command Output Budget" <<'EOF'
## Command Output Budget

- Cap broad command output by default, for example `COMMAND 2>&1 | head -c 4000`.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Memory And Spec" <<'EOF'
## Memory And Spec

- Persistent memory belongs under `memories/repo/**`; specs belong under `spec/**`.
- On first substantial plugin use, create missing scaffolds through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then verify paths on disk.
- Use progressive disclosure: read indexes first, then only relevant shards.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Agents and Dispatch" <<'EOF'
## Agents and Dispatch

- PM/coordinator owns intent, scope, dispatch, adjudication, closeout, and evolution signals.
- Delegated specialists return structured handbacks and route user questions through PM.
EOF

append_if_missing ".github/instructions/must.instructions.md" "## Implementation and Verification" <<'EOF'
## Implementation and Verification

- Prefer existing patterns. Public APIs, schemas, auth, dependencies, and CI/CD require blast-radius assessment.
- Before claiming work is done, run the smallest useful verification or state why it could not run.
EOF

append_if_missing ".github/instructions/must.instructions.md" "vscode_askQuestions" <<'EOF'
## Runtime Ask Fallback

- In VS Code, use `vscode_askQuestions` before other ask aliases when a native ask tool is available.
EOF

write_missing ".github/instructions/skills-index.instructions.md" <<'EOF'
---
name: target-repo-skills-index
description: Lightweight skill routing index for this repository.
applyTo: "**"
---

# Target Repository Skill Index

Read only the selected skill, not the whole skill tree.

## Initialization

- `repo-init-gate`: read only target-root `best-copilot.md` and decide whether full init is needed.
- `repo-init-scan`: use after gate failure; completion requires disk-verified target-local files, `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.
- `repo-init-official`: try official `/init` or `copilot init`; in Claude Code it uses the bounded native `/init` helper before manual fallback.
- `repo-init-manual-fallback`: create or repair scaffolds, verify required artifacts, and write `best-copilot.md`.
- `target-instructions-bootstrap`: create `.github/instructions/**` plus runtime adapters.
- `target-memory-bootstrap`: create `memories/repo/**` skeleton.
- `target-spec-bootstrap`: create `spec/**` skeleton and templates.

## Planning And Execution

- `core-workflow-contract`: shared workflow contract.
- Role workflow skills load with their matching agents.
- `change-verification` and `verification-before-completion`: prove changed behavior before closeout.

## Claude Code Skill Names

Use plugin skills with namespaced slash commands such as `/best-copilot:repo-init-gate` and `/best-copilot:repo-init-scan`. A `Skill(...) Successfully loaded` trace is not completion evidence; init still needs the explicit scan report and disk verification.
EOF

append_if_missing ".github/instructions/skills-index.instructions.md" "target-memory-bootstrap" <<'EOF'
## Initialization

- `repo-init-gate`: read only target-root `best-copilot.md` and decide whether full init is needed.
- `repo-init-scan`: use after gate failure; completion requires disk-verified target-local files, `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.
- `target-instructions-bootstrap`: create `.github/instructions/**` plus runtime adapters.
- `target-memory-bootstrap`: create `memories/repo/**` skeleton.
- `target-spec-bootstrap`: create `spec/**` skeleton and templates.
EOF

append_if_missing ".github/instructions/skills-index.instructions.md" "## Claude Code Skill Names" <<'EOF'
## Claude Code Skill Names

Use plugin skills with namespaced slash commands such as `/best-copilot:repo-init-gate` and `/best-copilot:repo-init-scan`. A `Skill(...) Successfully loaded` trace is not completion evidence; init still needs the explicit scan report and disk verification.
EOF

if [ "$compatibility" = "claude" ] || [ "$compatibility" = "claude-code" ]; then
  write_missing "CLAUDE.md" <<'EOF'
# Claude Code Project Entry

@.github/instructions/project.instructions.md
@.github/instructions/must.instructions.md
@.github/instructions/skills-index.instructions.md

## Claude Code Runtime

- The imported `.github/instructions/**` files are the shared source for repository facts, workflow gates, and skill routing.
- Start a Senior-owned session with `claude --agent senior-project-expert` or the configured Claude `agent` setting; use the scoped fallback if Claude reports a name collision.
- Use plugin skills with namespaced slash commands such as `/best-copilot:repo-init-gate` and `/best-copilot:repo-init-scan`.
- `Skill(...) Successfully loaded` is not proof that init ran. Continue only after `repo-init-scan` verifies files on disk and reports ready.
EOF

  mkdir -p ".claude"
  if [ ! -f ".claude/settings.json" ]; then
    cat >".claude/settings.json" <<'EOF'
{
  "agent": "senior-project-expert",
  "worktree": {
    "baseRef": "head"
  }
}
EOF
    created_paths="${created_paths}.claude/settings.json
"
  fi
fi

append_if_missing "CLAUDE.md" "@.github/instructions/project.instructions.md" <<'EOF'
@.github/instructions/project.instructions.md
@.github/instructions/must.instructions.md
@.github/instructions/skills-index.instructions.md
EOF

append_if_missing "CLAUDE.md" "@.github/instructions/must.instructions.md" <<'EOF'
@.github/instructions/must.instructions.md
EOF

append_if_missing "CLAUDE.md" "@.github/instructions/skills-index.instructions.md" <<'EOF'
@.github/instructions/skills-index.instructions.md
EOF

write_missing "memories/README.md" <<'EOF'
# Repository Memory

This directory stores target-local AI memory for this repository. Memory helps future sessions resume verified work without rereading every file. It does not override current repository files, command output, system instructions, or explicit user instructions.

## Layout

- `repo/INDEX.md`: routing table.
- `repo/current-workstreams.md`: active work and next resume action.
- `repo/project-state.md`: compact current state and constraints.
- `repo/workflow-rules.md`: memory/spec coordination rules.
- `repo/decisions.md`: durable dated decisions.
- `repo/logs/`: compressed logs loaded only on demand.
- `repo/archive/`: deprecated or historical memory.
EOF

write_missing "memories/repo/INDEX.md" <<'EOF'
# Repo Memory Index

| File | Load tier | Tags | Use for | Linked spec | Last updated | One-line summary |
| --- | --- | --- | --- | --- | --- | --- |
| `current-workstreams.md` | task-active | resume, progress | Resume current work and find next action | `spec/INDEX.md` | unknown | Active workstream summary |
| `project-state.md` | task-reference | project, status | Current state and constraints | `spec/INDEX.md` | unknown | Compact project state |
| `workflow-rules.md` | task-reference | workflow, memory, spec | Memory retrieval and spec coordination | `spec/INDEX.md` | unknown | Workflow rules |
| `decisions.md` | task-reference | decisions | Durable decisions | `spec/INDEX.md` | unknown | Date-stamped decisions |
| `logs/README.md` | archive-reference | logs | Compressed logs loaded on demand | none | unknown | Archive logs |
| `archive/deprecated-decisions.md` | archive-reference | archive, deprecated | Historical decisions | none | unknown | Deprecated decisions |
EOF

write_missing "memories/repo/current-workstreams.md" <<'EOF'
---
id: current-workstreams
type: active-state
updated_at: unknown
status: initialized
load_tier: task-active
tags: [resume, progress]
---

# Current Workstreams

## Active Topics

- None yet.

## Closed Topics

- None yet.
EOF

write_missing "memories/repo/project-state.md" <<'EOF'
---
id: project-state
type: project-memory
updated_at: unknown
status: initialized
tags: [project, state, constraints]
---

# Project State

## One-line Summary

unknown

## Current State

- Current focus: unknown
- Key acceptance signals: unknown
- Current risk: unknown
EOF

write_missing "memories/repo/workflow-rules.md" <<'EOF'
---
id: workflow-rules
type: repo-memory
updated_at: unknown
status: initialized
tags: [workflow, memory, spec]
---

# Workflow Rules

Memory never overrides current repo files, command output, system instructions, or explicit user instructions. Spec remains authoritative for requirements, design, and task acceptance.
EOF

write_missing "memories/repo/decisions.md" <<'EOF'
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
EOF

write_missing "memories/repo/logs/README.md" <<'EOF'
# Memory Logs

Store compressed, task-specific logs only when they are needed for future recovery. Do not store secrets, tokens, private data, or full chat transcripts.
EOF

write_missing "memories/repo/archive/deprecated-decisions.md" <<'EOF'
# Deprecated Decisions

Deprecated decisions and replacement links belong here.
EOF

write_missing "spec/INDEX.md" <<'EOF'
# Spec Index

| Directory | Tags | Last updated | Status | Linked memory | Summary |
| --- | --- | --- | --- | --- | --- |
| `spec/templates/` | template, requirements, design, tasks | unknown | template | `memories/repo/workflow-rules.md` | Reusable templates for new spec bundles |

## Maintenance Rules

- Every medium or large feature gets a spec directory with `requirements.md`, `design.md`, and `tasks.md`.
- Link active specs back to `memories/repo/current-workstreams.md`.
EOF

write_missing "spec/templates/requirements-template.md" <<'EOF'
# Requirements

## Metadata

- Status: `draft | reviewed | approved | closed`
- Linked design: `design.md`
- Linked tasks: `tasks.md`
- Linked memory: `memories/repo/current-workstreams.md`

## Goals

- `<observable outcome>`

## Non-Goals

- `<excluded behavior>`

## Functional Requirements

| ID | Requirement | Priority | Source | Acceptance Signal | Task Refs |
| --- | --- | --- | --- | --- | --- |
| FR-001 | `<The system must ...>` | P0 | `<source>` | `<check>` | `<task>` |

## Acceptance Criteria

- `<AC-001>`
EOF

write_missing "spec/templates/design-template.md" <<'EOF'
# Design

## Metadata

- Status: `draft | reviewed | approved | implemented | closed`
- Requirement source: `requirements.md`
- Task source: `tasks.md`

## Overview

- Problem summary: `<summary>`
- Chosen approach: `<smallest safe approach>`

## Proposed Changes

| Surface | Change | Owner lane | Verification |
| --- | --- | --- | --- |
| `<file/module>` | `<change>` | `<lane>` | `<check>` |
EOF

write_missing "spec/templates/tasks-template.md" <<'EOF'
# Tasks

## Metadata

- Status: `draft | approved | in-progress | closed`
- Requirement source: `requirements.md`
- Design source: `design.md`

## Task List

| ID | Task | Owner lane | Dependencies | Acceptance checks | Verification |
| --- | --- | --- | --- | --- | --- |
| T-001 | `<task>` | `<lane>` | none | `<checks>` | `<command>` |
EOF

required_paths=(
  ".github/instructions/project.instructions.md"
  ".github/instructions/must.instructions.md"
  ".github/instructions/skills-index.instructions.md"
  "memories/README.md"
  "memories/repo/INDEX.md"
  "memories/repo/current-workstreams.md"
  "memories/repo/project-state.md"
  "memories/repo/workflow-rules.md"
  "memories/repo/decisions.md"
  "memories/repo/logs/README.md"
  "memories/repo/archive/deprecated-decisions.md"
  "spec/INDEX.md"
  "spec/templates/requirements-template.md"
  "spec/templates/design-template.md"
  "spec/templates/tasks-template.md"
)

if [ "$compatibility" = "claude" ] || [ "$compatibility" = "claude-code" ]; then
  required_paths+=("CLAUDE.md")
fi

for rel_path in "${required_paths[@]}"; do
  check_file "$rel_path"
done

check_contains ".github/instructions/project.instructions.md" "## Init Status"
check_contains ".github/instructions/project.instructions.md" "Bootstrap contract version: 0.6.0"
check_contains ".github/instructions/must.instructions.md" "## Request Flow"
check_contains ".github/instructions/must.instructions.md" "## Per-Request Hard Gates"
check_contains ".github/instructions/must.instructions.md" "### PM Native Ask Trigger Gate"
check_contains ".github/instructions/must.instructions.md" "## Shared State Contracts"
check_contains ".github/instructions/must.instructions.md" "## Search Precision"
check_contains ".github/instructions/must.instructions.md" "## Command Output Budget"
check_contains ".github/instructions/must.instructions.md" "## Memory And Spec"
check_contains ".github/instructions/must.instructions.md" "## Agents and Dispatch"
check_contains ".github/instructions/must.instructions.md" "## Implementation and Verification"
check_contains ".github/instructions/must.instructions.md" "NEEDS_USER_INPUT"
check_contains ".github/instructions/must.instructions.md" "BLOCKED missing_top_level_question"
check_contains ".github/instructions/must.instructions.md" "work_mode"
check_contains ".github/instructions/must.instructions.md" "task_type"
check_contains ".github/instructions/must.instructions.md" "pm_action"
check_contains ".github/instructions/must.instructions.md" "fixed-string-before-regex"
check_contains ".github/instructions/must.instructions.md" "vscode_askQuestions"
check_contains ".github/instructions/must.instructions.md" "target-memory-bootstrap"
check_contains ".github/instructions/skills-index.instructions.md" "target-memory-bootstrap"
check_contains ".github/instructions/skills-index.instructions.md" "## Claude Code Skill Names"

if [ "$compatibility" = "claude" ] || [ "$compatibility" = "claude-code" ]; then
  check_contains "CLAUDE.md" "@.github/instructions/project.instructions.md"
  check_contains "CLAUDE.md" "@.github/instructions/must.instructions.md"
  check_contains "CLAUDE.md" "@.github/instructions/skills-index.instructions.md"
fi

if [ -z "$missing_paths" ] && [ -z "$content_errors" ]; then
  cat >"best-copilot.md" <<EOF
---
version: "$contract_version"
---
EOF
  check_file "best-copilot.md"
fi

verified_paths=""
if [ -z "$missing_paths" ] && [ -z "$content_errors" ] && [ -f "best-copilot.md" ]; then
  for rel_path in "${required_paths[@]}"; do
    verified_paths="${verified_paths}${rel_path}
"
  done
  verified_paths="${verified_paths}best-copilot.md
"
fi

if [ -n "$content_errors" ]; then
  missing_paths="${missing_paths}${content_errors}"
fi

echo "## Repo Init Manual Fallback Helper"
if [ -z "$missing_paths" ] && [ -f "best-copilot.md" ]; then
  echo "status=success"
  echo "required_artifacts_verified=yes"
  echo "sentinel_written=yes"
  echo "next_task_ready=yes"
  echo "verified_paths<<EOF"
  printf '%s' "$verified_paths"
  echo "EOF"
  echo "missing_paths=none"
  exit 0
fi

echo "status=blocked"
echo "required_artifacts_verified=no"
echo "sentinel_written=no"
echo "next_task_ready=no"
echo "verified_paths=none"
echo "missing_paths<<EOF"
printf '%s' "$missing_paths"
echo "EOF"
exit 70
