---
name: target-instructions-bootstrap
description: "Create the target repository's local AI instruction scaffold during first-use bootstrap. Use from repo-init-scan when `.github/instructions` or `AGENTS.md` is missing, including the neutral project facts scaffold. Do not use to overwrite existing project-specific rules."
---

# Target Instructions Bootstrap

Use this skill during `repo-init-scan` when target-local instruction entrypoints are missing. It may create a neutral `.github/instructions/project.instructions.md` scaffold, but that scaffold is not enough to pass initialization until `repo-init-scan` replaces the neutral markers with bounded repository facts or bounded-scan `unknown` gaps.

## Boundary

- Write into the target repository, never into the installed plugin package or plugin cache.
- Create missing files only. If a file exists, preserve it and append only a clearly compatible missing section.
- Do not copy this plugin repository's instruction files or active workflow state into the target repository. Generate only the neutral target-local scaffold below.
- Do not overwrite project-specific rules, language policy, build commands, or existing `AGENTS.md`.
- Keep generated files short. They are routing and safety scaffolds, not a full manual.

## Files

Create these files when absent:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `AGENTS.md` when the runtime includes Codex or the user wants Codex compatibility.

## `.github/instructions/project.instructions.md`

```markdown
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
| Install dependencies | unknown | Not yet verified. |
| Run tests | unknown | Not yet verified. |
| Run lint/checks | unknown | Not yet verified. |
| Start dev/runtime | unknown | Not yet verified. |

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

- unknown

## Verification Notes

- Init source: manual scaffold
- Last verified: unknown
```

## `.github/instructions/must.instructions.md`

```markdown
---
name: target-repo-must
description: Core AI rules for this repository.
applyTo: "**"
---

# Target Repository AI Rules

## Priority

System, platform, and explicit user instructions outrank repository files. Current repository files and command output outrank memory, old specs, and external references.

## Per-Request Hard Gates

- Before sending final prose directly to the user, if the latest user message was not an explicit native closeout confirmation choosing to end the turn or stating there are no further instructions, first trigger a native closeout prompt through `ask_user`, `vscode/askQuestions`, `askQuestions`, or an equivalent structured choice UI. Do not close on prose-only summary.
- Native ask availability must be judged from the latest runtime tool inventory. If a native ask tool is available now, use it immediately; do not reuse an older "native UI unavailable" conclusion.
- If a previous turn could only return a staged, blocked, or partial prose response because native ask was unavailable, and the latest tool inventory or tool-change notice restores `ask_user`, `vscode/askQuestions`, `askQuestions`, or an equivalent native UI, the next direct closeout must first perform a native closeout prompt. Earlier prose does not become retroactive closeout authorization.
- If the user replies through a native closeout or continuation prompt with free text, technical feedback, a selected continuation, a file path, a fix request, an investigation direction, or any new executable instruction, that reply is a new ordinary user message. The previous closeout state is invalidated immediately.
- When a closeout/continuation reply contains new executable work, do the substantial action for that new task next, or ask one minimal native clarification if it is genuinely ambiguous. Do not send another summary-only response or another closeout prompt first.
- Answer-only follow-ups such as why/how questions, principle explanations, solution comparisons, rule clarifications, and review-response discussion are not closeout exemptions. If the answer would be the last prose message in the current batch, trigger a fresh native closeout prompt after answering and before ending.

## Repository Truth

- Read `.github/instructions/project.instructions.md` before non-trivial work.
- Treat `.github/instructions/project.instructions.md` as initialized only when it is not the untouched neutral scaffold, contains concrete build/test/check/dev command facts or bounded-scan `unknown`, plus runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown`.
- If facts are missing, run the repository init flow before real requirements analysis. This is a fail-closed gate: do not continue to dependency/framework changes, security rewrites, planning, or implementation until `.github/instructions/project.instructions.md` exists and is verified.
- Do not guess project stack, module ownership, security boundaries, or build commands.

## Memory And Spec

- Persistent memory belongs in this target repository under `memories/repo/**`.
- Specs belong in this target repository under `spec/**`.
- Memory/spec templates come from bootstrap skills and are not active state for this project until created in the target repository.
- On first substantial plugin use, if `.github/instructions/**`, `memories/repo/**`, or `spec/**` scaffolds are missing, create them through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then verify the paths on disk before substantive work. If they cannot be created, stop with `BLOCKED first_use_gate_incomplete` and list the missing paths.
- MEDIUM/LARGE active work should link both ways: spec points to memory, and `memories/repo/current-workstreams.md` points to spec.
- Memory stores recovery state, decisions, and verified facts. Spec stores requirements, design, tasks, and acceptance checks.

## Interaction

- Use the user's primary language unless they ask otherwise.
- Ask only when blocked by a real decision, missing context, destructive action, or materially different implementation route.
- If a native ask UI exists, use it for blocking route, approval, or continuation choices.

## Verification

- Before claiming work is done, run the smallest useful verification available or state exactly why it could not run.
- Record important verification evidence in the task closeout and update memory/spec for larger work.
- Do not store secrets, tokens, private logs, or PII in durable memory, specs, or instructions.
```

## `.github/instructions/skills-index.instructions.md`

```markdown
---
name: target-repo-skills-index
description: Lightweight skill routing index for this repository.
applyTo: "**"
---

# Target Repository Skill Index

Read only the selected skill, not the whole skill tree.

## Initialization

- `repo-init-scan`: first substantial task, missing scaffolds, missing or placeholder `.github/instructions/project.instructions.md`, or incomplete `/init` output.
- `target-instructions-bootstrap`: create missing `.github/instructions/**` and optional `AGENTS.md`.
- `target-memory-bootstrap`: create missing `memories/repo/**` skeleton.
- `target-spec-bootstrap`: create missing `spec/**` skeleton and spec templates.

## Planning And Execution

- `brainstorming`: ambiguous MEDIUM/LARGE direction before spec or code.
- `writing-plans`: confirmed MEDIUM/LARGE direction into executable tasks.
- `spec-review-gauntlet`: pre-implementation readiness and multi-lane design review for Spec Bundles and execution plans.
- `executing-plans`: approved tasks.md or multi-step plan execution with checkpoints, verification evidence, and per-task review.
- `subagent-driven-development`: fresh-context specialist execution for approved plans, requiring implementation, spec-compliance review, code-quality review, and verification per task.
- `spec-execution-fastpath`: clear requirement or spec with minimal diff.
- `test-driven-development`: new behavior or bug fix where a focused failing test is practical.
- `systematic-debugging`: unknown root cause or failing behavior.
- `root-cause-investigation`: failure evidence exists and scope is narrow.

## Context And Review

- `search-fastpath`: target files are unclear or search is becoming expensive.
- `context-packet-fastpath`: prepare or consume a minimal handoff packet.
- `change-verification`: prove changed behavior after edits.
- `verification-before-completion`: final evidence check before closeout.
- `structured-review`: review code, customization, design, review handoff, feedback intake, and targeted re-review.
```

## `AGENTS.md`

```markdown
# Codex Repository Entry

This file is the Codex adapter for the target repository. `.github/**` is the shared source of repository AI rules when it exists. System, platform, and explicit user instructions have higher priority than repository files.

## Required Entries

1. `.github/instructions/project.instructions.md`: repository facts, build/test commands, and high-frequency conventions.
2. `.github/instructions/must.instructions.md`: core local AI rules.
3. `.github/instructions/skills-index.instructions.md`: lightweight skill routing index.
4. `memories/repo/INDEX.md` and `memories/repo/current-workstreams.md`: task memory routing and progress recovery when present.
5. `spec/INDEX.md`: active spec routing when present.

## Runtime Rules

- Before non-trivial work, read the relevant parts of `.github/instructions/project.instructions.md` and `.github/instructions/must.instructions.md`.
- When choosing a skill, read `.github/instructions/skills-index.instructions.md` first, then open only the selected skill.
- When resuming multi-step work, read `memories/repo/INDEX.md`, then `current-workstreams.md`, then only linked spec or memory shards.
- Do not treat plugin package state as active project state.
- Detect the user's primary language and answer in that language unless the user asks otherwise.
```

## Verification

- Confirm generated files exist in the target repository.
- Confirm existing files were not overwritten.
- Confirm no generated file contains unresolved project-specific claims, secrets, or plugin-cache paths.
- If this skill was invoked because `.github/instructions/**` was missing and the required files still do not exist after the attempt, return `BLOCKED target_instructions_bootstrap_incomplete` with the missing paths. Do not let the caller continue the substantive task as if initialization succeeded.
