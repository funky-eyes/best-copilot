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
- Keep generated files runtime-neutral across Copilot CLI, Claude Code, VS Code Copilot, and Codex. If a runtime-specific command is mentioned, label it as runtime-specific.

## Files

Create these files when absent, and repair them when present but missing the
required runtime-neutral scaffold sections below:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `AGENTS.md` when the runtime includes Codex or the user wants Codex compatibility.

Existing target files must be handled as follows:

- Never replace an existing file wholesale.
- If `.github/instructions/must.instructions.md` exists but lacks `## Per-Request Hard Gates`, append that whole section exactly as shown in this skill before `## Repository Truth` when that heading exists, otherwise append it after `## Priority`.
- If `.github/instructions/must.instructions.md` exists but its hard gates do not distinguish PM/coordinator or directly user-invoked specialists from PM-delegated specialists, repair that section from this skill.
- If `.github/instructions/must.instructions.md` exists but lacks the first-use scaffold gate under `## Memory And Spec`, append the missing bullet from this skill into that section.
- If `.github/instructions/must.instructions.md` exists but lacks `## Search Precision`, append that section from this skill.
- If `.github/instructions/must.instructions.md` exists but lacks `## Command Output Budget`, append that section from this skill after `## Search Precision` when that heading exists, otherwise append it before `## Memory And Spec` when possible.
- If `.github/instructions/skills-index.instructions.md` exists but lacks the Claude Code skill-name note, append `## Claude Code Skill Names` from this skill.
- If a required section cannot be inserted without overwriting project-specific rules, stop with `BLOCKED target_instructions_bootstrap_conflict` and list the conflicting file.

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

- Before sending final prose directly to the user, if the latest user message was not an explicit native closeout confirmation choosing to end the turn or stating there are no further instructions, only the top-level session, PM/coordinator, or a specialist directly invoked by the user may trigger a native closeout prompt through `ask_user`, `vscode/askQuestions`, `askQuestions`, or an equivalent structured choice UI. Do not close on prose-only summary.
- PM-delegated specialists must not ask the user directly and must not use native closeout prompts. If user input, approval, or route selection is needed, return `NEEDS_USER_INPUT` to PM/coordinator with `question`, `why_blocking`, `options` when applicable, `safe_default` when one exists, and `resume_prompt_for_pm`.
- When a closeout or continuation choice is needed, present the decision surface through the native ask UI itself rather than a prose summary plus options list. Do not mix a written `1/2/3` choice list into the same closing prose; keep the actual selectable options in the structured prompt.
- Native ask availability must be judged from the latest runtime tool inventory. If a native ask tool is available now, use it immediately; do not reuse an older "native UI unavailable" conclusion.
- If a previous turn could only return a staged, blocked, or partial prose response because native ask was unavailable, and the latest tool inventory or tool-change notice restores `ask_user`, `vscode/askQuestions`, `askQuestions`, or an equivalent native UI, the next direct closeout must first perform a native closeout prompt. Earlier prose does not become retroactive closeout authorization.
- If the user replies through a native closeout or continuation prompt with free text, technical feedback, a selected continuation, a file path, a fix request, an investigation direction, or any new executable instruction, that reply is a new ordinary user message. The previous closeout state is invalidated immediately.
- When a closeout/continuation reply contains new executable work, do the substantial action for that new task next, or ask one minimal native clarification if it is genuinely ambiguous. Do not send another summary-only response or another closeout prompt first.
- Answer-only follow-ups such as why/how questions, principle explanations, solution comparisons, rule clarifications, and review-response discussion are not closeout exemptions. If the answer would be the last prose message in the current batch, trigger a fresh native closeout prompt after answering and before ending.
- Do not reinterpret any final-answer formatting rule, brevity rule, or “provide a summary/next steps” instruction as permission to skip the native ask step. Closeout gating wins over stylistic closeout guidance.

## Repository Truth

- Read `.github/instructions/project.instructions.md` before non-trivial work.
- Treat `.github/instructions/project.instructions.md` as initialized only when it is not the untouched neutral scaffold, contains concrete build/test/check/dev command facts or bounded-scan `unknown`, plus runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown`.
- If facts are missing, run the active runtime's repository init flow before real requirements analysis. Use `/init` when available in Copilot CLI, VS Code Copilot, or Claude Code; use `copilot init` only when the Copilot CLI command exists. This is a fail-closed gate: do not continue to dependency/framework changes, security rewrites, planning, or implementation until `.github/instructions/project.instructions.md` exists and is verified.
- Do not guess project stack, module ownership, security boundaries, or build commands.

## Search Precision

- Start from user-provided paths, changed files, `.github/instructions/project.instructions.md`, and target-local `spec/INDEX.md` / `memories/repo/INDEX.md` before content search.
- Prefer exact filename/glob lookup and fixed-string `rg -F` for class names, method names, route strings, config keys, command names, and copied errors.
- Use regex only when the user description is vague, the exact literal is unknown, or earlier exact/fixed-string searches failed.
- Avoid repo-wide regex; scope searches to the smallest likely directory and stop after two searches with no new signal.

## Command Output Budget

- Protect context usage before command output enters the prompt. Any command with unknown, potentially large, repo-wide, or log-like output must be byte-capped by default.
- Default shell pattern: `COMMAND 2>&1 | head -c 4000`.
- Raise the cap only for a scoped file window or specific verification need; prefer focused reruns over pasting full logs.
- If a capped result truncates critical evidence, rerun a narrower command. Do not use output caps to hide failures, skip verification, or omit important error details.

## Memory And Spec

- Persistent memory belongs in this target repository under `memories/repo/**`.
- Specs belong in this target repository under `spec/**`.
- Memory/spec templates come from bootstrap skills and are not active state for this project until created in the target repository.
- On first substantial plugin use, if `.github/instructions/**`, `memories/repo/**`, or `spec/**` scaffolds are missing, create them through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then verify the paths on disk before substantive work. If they cannot be created, stop with `BLOCKED first_use_gate_incomplete` and list the missing paths.
- MEDIUM/LARGE active work should link both ways: spec points to memory, and `memories/repo/current-workstreams.md` points to spec.
- Memory stores recovery state, decisions, and verified facts. Spec stores requirements, design, tasks, and acceptance checks.

## Interaction

- Use the user's primary language unless they ask otherwise.
- Ask only when blocked by a real decision, missing context, destructive action, or materially different implementation route, and only when you are the top-level session, PM/coordinator, or directly invoked by the user.
- If a native ask UI exists, use it for blocking route, approval, or continuation choices.
- If you are a PM-delegated specialist, return `NEEDS_CONTEXT` for missing repository/task context and `NEEDS_USER_INPUT` for questions that require the human; PM/coordinator owns the actual user prompt.

## Runtime Notes

- In Copilot CLI, plugin agents normally appear through `/agent`, and plugin skills appear through the runtime's skills interface.
- In Claude Code, plugin skills are namespaced as `/best-copilot:<skill-name>` after installation, plugin subagents appear in `/agents`, and agent teams can reference plugin subagent types by scoped name such as `best-copilot:technical-architect`.
- When Claude Code uses a subagent definition as an agent-team teammate, the subagent's `skills` frontmatter is not automatically applied. The lead must tell the teammate to invoke the needed namespaced skill or include the needed checklist in the spawn prompt.

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

- `core-workflow-contract`: shared cross-role source priority, runtime adapters, init gates, handoff packet shape, review/verification, memory/spec, and closeout rules.
- Role workflow skills: load one matching the active agent role together with `core-workflow-contract`.
  - `senior-project-expert-workflow`: PM/coordinator scope, routing, dispatch, fan-in, closeout, and evolution signals.
  - `specification-writer-workflow`: requirements, design, tasks, ADRs, closeout records, and memory/spec recovery.
  - `technical-architect-workflow`: architecture, service boundaries, data/API contracts, blast radius, and mainline implementation strategy.
  - `developer-workflow`: frozen implementation slices, scoped peer review, `NEEDS_CONTEXT` / `NEEDS_USER_INPUT`, and verification evidence.
  - `frontend-designer-workflow`: UI implementation/review, design-system reuse, responsive/browser evidence, and visual quality.
  - `quality-assurance-workflow`: functional verification, regression risk, test sufficiency, and merge-readiness review.
  - `security-reviewer-workflow`: auth, permissions, dependencies, secrets, release surfaces, and sensitive data review.
  - `root-cause-fixer-workflow`: concrete failure evidence, minimal root-cause patching, and regression proof.
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

## Claude Code Skill Names

After installing this plugin in Claude Code, invoke plugin skills as `/best-copilot:<skill-name>`, for example `/best-copilot:repo-init-scan`, `/best-copilot:structured-review`, and `/best-copilot:verification-before-completion`. Invoke plugin subagents with scoped names such as `best-copilot:senior-project-expert`.
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
- When running under Claude Code, use plugin skills as `/best-copilot:<skill-name>` and plugin subagents through `/agents` or agent teams with scoped names such as `best-copilot:senior-project-expert`.
```

## Verification

- Confirm generated files exist in the target repository.
- path existence alone is not enough; required sections must also be present after create or repair.
- Confirm existing files were not overwritten.
- Confirm `.github/instructions/must.instructions.md` contains `## Per-Request Hard Gates`, all native-closeout bullets from this skill, and the PM-delegated specialist `NEEDS_USER_INPUT` rule.
- Confirm `.github/instructions/must.instructions.md` contains `## Search Precision` and the fixed-string-before-regex rule.
- Confirm `.github/instructions/must.instructions.md` contains `## Command Output Budget` and the default `COMMAND 2>&1 | head -c 4000` pattern.
- Confirm `.github/instructions/must.instructions.md` contains the first-use scaffold gate that names `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- Confirm `.github/instructions/skills-index.instructions.md` contains the Claude Code skill-name note when that file exists.
- Confirm no generated file contains unresolved project-specific claims, secrets, or plugin-cache paths.
- If this skill was invoked because `.github/instructions/**` was missing and the required files still do not exist after the attempt, return `BLOCKED target_instructions_bootstrap_incomplete` with the missing paths. Do not let the caller continue the substantive task as if initialization succeeded.
