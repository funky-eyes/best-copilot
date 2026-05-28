---
name: target-instructions-bootstrap
description: "Create the target repository's local AI instruction scaffold during first-use bootstrap. Use from repo-init-scan when `.github/instructions`, runtime adapters such as `AGENTS.md` / `CLAUDE.md`, or the neutral project facts scaffold are missing. Do not use to overwrite existing project-specific rules."
---

# Target Instructions Bootstrap

Use this skill during `repo-init-scan` when target-local instruction entrypoints are missing. It may create a neutral `.github/instructions/project.instructions.md` scaffold, but that scaffold is not enough to pass initialization until `repo-init-scan` replaces the neutral markers with bounded repository facts or bounded-scan `unknown` gaps, updates the `## Init Status` record, and writes the root `best-copilot.md` version sentinel after full verification.

## Boundary

- Write into the target repository, never into the installed plugin package or plugin cache.
- Create missing files only. If a file exists, preserve it and append only a clearly compatible missing section.
- Do not copy this plugin repository's instruction files or active workflow state into the target repository. Generate only the neutral target-local scaffold below.
- Do not overwrite project-specific rules, language policy, build commands, or existing `AGENTS.md` / `CLAUDE.md`.
- Keep generated files short. They are routing and safety scaffolds, not a full manual.
- Keep generated files runtime-neutral across Copilot CLI, Claude Code, VS Code Copilot, and Codex. If a runtime-specific command is mentioned, label it as runtime-specific.
- Do not generate, require, or assume plugin hooks, local scripts, Python, Node, shell, or other interpreter-based closeout enforcement. The native-ask and closeout gates must be self-contained instruction text because target repositories may not have those runtimes installed.
- Do not create `best-copilot.md` in this skill. That file is the verified-init sentinel and must be written only by `repo-init-scan` after the full initialization barrier passes.

## Verified Init Sentinel

`repo-init-scan` writes the target root `best-copilot.md` only after full init verification. Its expected content is:

```md
---
version: "0.5.0"
---
```

## Files

Create these files when absent, and repair them when present but missing the
required runtime-neutral scaffold sections below:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `AGENTS.md` when the runtime includes Codex or the user wants Codex compatibility.
- `CLAUDE.md` when the runtime is Claude Code or the user wants Claude Code compatibility.
- `.claude/settings.json` when the runtime is Claude Code and the user wants a stable Senior Project Expert session entry plus current-branch worktree base.

Existing target files must be handled as follows:

- Never replace an existing file wholesale.
- If a listed insertion heading is absent, append the required compatible section at the end of the file instead of silently skipping repair.
- If `.github/instructions/must.instructions.md` exists but lacks `## Request Flow`, append that whole section exactly as shown in this skill after `## Priority`.
- If `.github/instructions/must.instructions.md` exists but lacks `## Per-Request Hard Gates`, append that whole section exactly as shown in this skill before `## Repository Truth` when that heading exists, otherwise append it after `## Request Flow` when that heading exists, or after `## Priority`.
- If `.github/instructions/must.instructions.md` exists but its hard gates do not reserve native user prompts to the top-level session or PM/coordinator, repair that section from this skill.
- If `.github/instructions/must.instructions.md` exists but lacks `### No Silent Closeout`, append that subsection from this skill under `## Per-Request Hard Gates`.
- If `.github/instructions/must.instructions.md` exists but `### No Silent Closeout` relies on plugin hooks, local scripts, Python, Node, shell, or other interpreter-based enforcement, repair that subsection to the instruction-only wording from this skill.
- If `.github/instructions/must.instructions.md` exists but lacks `### PM Native Ask Trigger Gate`, append that subsection from this skill under `## Per-Request Hard Gates`.
- If `.github/instructions/must.instructions.md` exists but lacks `## Shared State Contracts`, append that section from this skill after `## Repository Truth` when that heading exists, otherwise append it after `## Per-Request Hard Gates`.
- If `.github/instructions/must.instructions.md` exists but lacks `### Fan-In Arbitration`, append that subsection from this skill under `## Shared State Contracts`.
- If `.github/instructions/must.instructions.md` exists but lacks `## Memory And Spec`, append that section from this skill after `## Command Output Budget` when that heading exists, otherwise append it after `## Shared State Contracts`.
- If `.github/instructions/must.instructions.md` exists but lacks the first-use scaffold gate under `## Memory And Spec`, append the missing bullet from this skill into that section.
- If `.github/instructions/must.instructions.md` exists but lacks the progressive-disclosure memory rule under `## Memory And Spec`, append that bullet from this skill into that section.
- If `.github/instructions/must.instructions.md` exists but lacks `## Search Precision`, append that section from this skill.
- If `.github/instructions/must.instructions.md` exists but lacks `## Command Output Budget`, append that section from this skill after `## Search Precision` when that heading exists, otherwise append it before `## Memory And Spec` when possible.
- If `.github/instructions/must.instructions.md` exists but lacks `## Interaction`, append that section from this skill after `## Memory And Spec` when that heading exists, otherwise append it after `## Command Output Budget`.
- If `.github/instructions/must.instructions.md` exists but lacks the mixed-language rule under `## Interaction`, append that bullet from this skill into that section.
- If `.github/instructions/must.instructions.md` exists but lacks `## Agents and Dispatch`, append that section from this skill after `## Runtime Notes` when that heading exists, otherwise append it after `## Memory And Spec`.
- If `.github/instructions/must.instructions.md` exists but lacks `## Implementation and Verification`, append that section from this skill after `## Agents and Dispatch` when that heading exists, otherwise append it after `## Runtime Notes` when that heading exists, or after `## Interaction`.
- If `.github/instructions/skills-index.instructions.md` exists but lacks the Claude Code skill-name note, append `## Claude Code Skill Names` from this skill.
- If `CLAUDE.md` exists but lacks references to `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, and `.github/instructions/skills-index.instructions.md`, append the compatible import block from this skill instead of replacing existing Claude-specific rules.
- If `.claude/settings.json` exists but lacks a top-level `agent` key and adding JSON safely is possible, add `"agent": "senior-project-expert"` while preserving existing keys. If it already has a different `agent`, do not overwrite it silently; stop with `BLOCKED target_instructions_bootstrap_conflict` unless the user explicitly asked to change the Claude default agent. If `.claude/settings.json` lacks `worktree.baseRef` and adding JSON safely is possible, add `"worktree": {"baseRef": "head"}` while preserving existing keys; if it already has a different worktree policy, preserve it and record the difference instead of overwriting. If safe JSON repair is not possible, stop with `BLOCKED target_instructions_bootstrap_conflict` and list `.claude/settings.json`.
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

## Init Status

- Init ready: no
- Required artifacts verified: no
- Bootstrap contract version: 0.5.0
- Last full verification: unknown
- Reentry rule: best-copilot-version-sentinel-first
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

## Request Flow

1. Parse literal request, real intent, and success criteria.
2. Before the first substantial action in a turn, record a per-request start timestamp. If that timestamp was missed, do not backfill a fake duration later.
3. Read explicit user paths and any `/init` or `copilot init` artifacts first. If repository facts are incomplete, normalize official init output into `.github/instructions/project.instructions.md`; command output without that file is `official_init_no_write`, and substantive work stays blocked until the file exists and is verified.
4. Before editing, freeze a minimal packet with at least `goal`, `scope`, `constraints`, `expected_outcome`, `acceptance_checks`, `verification_budget`, `work_mode`, and `task_type`. When multi-agent dispatch is used, preserve the shared six-block packet from `core-workflow-contract`.
5. Search at most three rounds and stop after two rounds with no new signal. Prefer explicit paths, filename/glob lookup, and fixed-string `rg -F` before regex.
6. Before completion, provide real verification evidence or state the blocker explicitly.

## Per-Request Hard Gates

### No Silent Closeout

- Do not end a turn with a prose-only summary, recap, recommendation, or next-steps paragraph.
- Any response that would be the last assistant message in the turn counts as a closeout candidate.
- Before any such response, if a native ask tool is available in the latest runtime tool inventory, the top-level session or PM/coordinator must use it and wait for the result. Do not replace the native prompt with prose.
- If native ask is unavailable and the latest user message was not an explicit closeout confirmation, return `BLOCKED missing_native_ask_ui` or `DONE_WITH_CONCERNS missing_native_ask_ui` with the exact question, options, safe default when one exists, and resume state. Do not improvise a prose closeout.
- If the native ask reply contains free text or a new instruction, treat it as a new ordinary user request and continue from there.
- This gate must be enforced from instruction text alone. Do not rely on plugin hooks, local scripts, Python, Node, shell, or any other runtime-specific interpreter as the default closeout backstop.

- Before sending final prose directly to the user, if the latest user message was not an explicit native closeout confirmation choosing to end the turn or stating there are no further instructions, only the top-level session or PM/coordinator may trigger a native closeout prompt. In VS Code, if `vscode_askQuestions` appears in the latest tool inventory, call that exact tool first; do not stop at abstract `vscode/askQuestions` or `askQuestions` capability text. In Copilot CLI, use `Asking user` when available. Do not close on prose-only summary.
- Specialists must not ask the user directly and must not use native closeout prompts. Copilot specialist agent frontmatter must not include `Asking user`, `vscode_askQuestions`, `vscode/askQuestions`, `askQuestions`, or equivalent user-facing ask tools. If PM/coordinator is present, return `NEEDS_USER_INPUT` with `question`, `why_blocking`, `options` when applicable, `safe_default` when one exists, and `resume_prompt_for_pm`. Otherwise return `BLOCKED` or `DONE_WITH_CONCERNS` with `missing_top_level_question` and the exact question that the top-level session or PM/coordinator should ask.
- When a closeout or continuation choice is needed, present the decision surface through the native ask UI itself rather than a prose summary plus options list. Do not mix a written `1/2/3` choice list into the same closing prose; keep the actual selectable options in the structured prompt.
- Native ask prompts must include a custom free-form answer path. If the UI only supports fixed choices, include `Custom answer` and follow that selection with a native/free-form prompt before deciding.
- Native ask availability must be judged from the latest runtime tool inventory. If a native ask tool is available now, use it immediately; do not reuse an older "native UI unavailable" conclusion. In VS Code, `vscode_askQuestions` outranks abstract `vscode/askQuestions` / `askQuestions` wording when present.
- If a previous turn could only return a staged, blocked, or partial prose response because native ask was unavailable, and the latest tool inventory or tool-change notice restores `Asking user`, `vscode_askQuestions`, `vscode/askQuestions`, `askQuestions`, or an equivalent native UI, the next direct closeout must first perform a native closeout prompt. Earlier prose does not become retroactive closeout authorization.
- If the user replies through a native closeout or continuation prompt with free text, technical feedback, a selected continuation, a file path, a fix request, an investigation direction, or any new executable instruction, that reply is a new ordinary user message. The previous closeout state is invalidated immediately.
- When a closeout/continuation reply contains new executable work, do the substantial action for that new task next, or ask one minimal native clarification if it is genuinely ambiguous. Do not send another summary-only response or another closeout prompt first.
- Answer-only follow-ups such as why/how questions, principle explanations, solution comparisons, rule clarifications, and review-response discussion are not closeout exemptions. If the answer would be the last prose message in the current batch, trigger a fresh native closeout prompt after answering and before ending.
- Do not reinterpret any final-answer formatting rule, brevity rule, or “provide a summary/next steps” instruction as permission to skip the native ask step. Closeout gating wins over stylistic closeout guidance.

### PM Native Ask Trigger Gate

- Native ask is not owned by one focused skill. The top-level session or PM/coordinator must use it for every blocking clarification, route choice, execution approval, specialist `NEEDS_USER_INPUT` handback, continuation choice, and closeout choice when the runtime exposes native ask.
- Do not treat brainstorming as the only native-ask trigger. Review, verification, workspace isolation, branch closeout, and answer-only follow-ups use the same native ask path when they require a user decision or closeout.
- If a PM/coordinator adapter frontmatter declares `Asking user`, `vscode_askQuestions`, `vscode/askQuestions`, or `askQuestions`, treat that declaration as an availability signal and attempt the concrete native ask before any prose fallback.
- A "native ask unavailable" statement is valid only after checking the latest tool inventory and confirming the concrete tool is absent or impossible in the current runtime.
- If native ask is unavailable and a human choice still blocks progress or closeout, return `BLOCKED missing_native_ask_ui` or `DONE_WITH_CONCERNS missing_native_ask_ui` with the exact question, options, safe default when one exists, and resume state. Do not replace the popup with a prose-only question.

## Repository Truth

- Read `.github/instructions/project.instructions.md` before non-trivial work.
- Treat `.github/instructions/project.instructions.md` as initialized only when it is not the untouched neutral scaffold, contains concrete build/test/check/dev command facts or bounded-scan `unknown`, plus runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown`.
- If facts are missing, run the active runtime's repository init flow before real requirements analysis. Use `/init` when available in Copilot CLI, VS Code Copilot, or Claude Code; use `copilot init` only when the Copilot CLI command exists. This is a fail-closed gate: do not continue to dependency/framework changes, security rewrites, planning, or implementation until `.github/instructions/project.instructions.md` exists and is verified.
- Do not guess project stack, module ownership, security boundaries, or build commands.

## Shared State Contracts

- `work_mode` is the scope/orchestration field. Allowed values: `micro | standard | full`.
- `task_type` is the execution-mode field. Allowed values: `implementation | design_review | verification | fix | spec`.
- `planning_state`, `execution_confirmed`, and `decision_provenance` are owned only by the top-level session or PM/coordinator.
- `pm_action` is a delegated handback control field used only with `status=NEEDS_CONTEXT`. The current allowed value is `pm_clarify`, which tells PM/coordinator to repair the packet or clarify missing context before redispatch.
- Delegated specialists return structured handbacks. Missing repository/task context returns `NEEDS_CONTEXT`. Missing human choice returns `NEEDS_USER_INPUT` to PM/coordinator when one exists, otherwise `BLOCKED` or `DONE_WITH_CONCERNS` with `missing_top_level_question`.
- When consuming older dispatch prompts that still use `TASK`, `EXPECTED OUTCOME`, `REQUIRED TOOLS`, `MUST DO`, `MUST NOT DO`, or `CONTEXT`, normalize them into the current packet before further delegation.

### Fan-In Arbitration

- PM/coordinator adjudicates fan-in before marking tasks complete or continuing fan-out. Priority order: blocker or invalid handback, security/privacy/data-loss/auth/dependency/release risk, failed or missing verification, spec/acceptance mismatch, overlapping write sets, code-quality or UX/test-sufficiency concerns, then non-blocking follow-up notes.
- If reviewers disagree, PM records `decision_provenance` with deciding evidence, blocking status, next stage, and residual risk. Do not close from an unadjudicated conflict.

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
- On first substantial plugin use, if `.github/instructions/**`, runtime adapters, `memories/repo/**`, or `spec/**` scaffolds are missing, create them through `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then verify the paths on disk before substantive work. For Claude Code target use, create or verify a project `CLAUDE.md` that imports the `.github/instructions/**` files, because Claude does not automatically load Copilot instruction paths. If required scaffolds cannot be created, stop with `BLOCKED first_use_gate_incomplete` and list the missing paths.
- MEDIUM/LARGE active work should link both ways: spec points to memory, and `memories/repo/current-workstreams.md` points to spec.
- Memory stores recovery state, decisions, and verified facts. Spec stores requirements, design, tasks, and acceptance checks.
- Use progressive disclosure: read routing indexes and current workstream state first, then only the linked or relevant shards. Do not load whole memory trees, whole specs, or logs by default.

## Interaction

- Use the user's primary language unless they ask otherwise.
- For mixed-language input, treat the language used for the actual request or explanation as primary; pasted code, logs, stack traces, and file content do not override it.
- Ask only when blocked by a real decision, missing context, destructive action, or materially different implementation route, and only when you are the top-level session or PM/coordinator.
- If a native ask UI exists, use it for blocking route, approval, or continuation choices. In VS Code, prefer the concrete `vscode_askQuestions` tool when present; in Copilot CLI, prefer `Asking user`.
- If you are a specialist, return `NEEDS_CONTEXT` for missing repository/task context and route human questions through `NEEDS_USER_INPUT` when PM/coordinator is present, or `BLOCKED missing_top_level_question` otherwise; the actual user prompt belongs to the top-level session or PM/coordinator.

## Runtime Notes

- In Copilot CLI, plugin agents normally appear through `/agent`, and plugin skills appear through the runtime's skills interface.
- In Claude Code, plugin skills are invoked with namespaced slash commands such as `/best-copilot:repo-init-gate`; if the command picker inserts another displayed form for the enabled plugin, use that exact picker value. Plugin subagents appear in `/agents` with scoped names such as `best-copilot:technical-architect`; use the exact displayed names for manual `@` mentions and explicit Agent-tool dispatch. For a Senior-owned main session, start with `--agent senior-project-expert` or set Claude's `agent` setting to `senior-project-expert`; if Claude reports an agent-name collision, use scoped `best-copilot:senior-project-expert`.
- If Claude Code resolves the Senior Project Expert request through the skill path instead of the subagent path, the compatibility skill must run the same `repo-init-gate` / `repo-init-scan` preflight before substantive work.
- Claude Code Agent tool subagents receive their own agent definition, including their `skills:` frontmatter; the PM spawn prompt should still name required skills and pass current `INIT_GATE` / `INIT_SCAN` evidence as fallback.
- If any best-copilot specialist is invoked directly for target-repository work without a PM packet containing current `INIT_GATE` / `INIT_SCAN` evidence, run `repo-init-gate` before broad search, generic Explore, planning, review, or implementation; run `repo-init-scan` only if the gate fails.

## Agents and Dispatch

- The PM/coordinator owns intent, scope, dispatch, adjudication, closeout, and evolution signals. It does not write production code for medium or large work.
- Parallel subtasks are allowed only when file write sets do not overlap.
- Multi-agent dispatch should preserve the shared six-block contract: `task_intent`, `frozen_scope`, `fact_packet`, `execution_contract`, `review_state`, and `output_contract`, plus current `INIT_GATE` / `INIT_SCAN` evidence.
- Delegated specialists do not ask users directly. If repository or task context is missing, return `NEEDS_CONTEXT`; if human input or approval is required, return `NEEDS_USER_INPUT` for PM/coordinator to ask.
- Delegated handbacks must preserve shared field names such as `task_id`, `current_stage`, `status`, `summary`, `artifacts`, `risks`, `uncovered_items`, `recommended_next_stage`, and when blocked on missing context, `clarification_request` plus `pm_action: "pm_clarify"`.
- For large ambiguous work, PM delegates SDD design brainstorming to Technical Architect first. Technical Architect self-reviews and repairs the design before PM asks Developer and Quality Assurance Expert for second-pass review; add Frontend Designer review for frontend/user-visible surfaces. Only a blocker-free reviewed design proceeds to implementation.
- Cross-review implementation lanes: Developer-authored code -> Technical Architect review; Technical Architect-authored code -> Developer review; frontend code by Developer/Technical Architect -> Frontend Designer review; Frontend Designer-authored code -> Technical Architect review.

## Implementation and Verification

- Prefer existing code, tools, components, and patterns.
- Public APIs, message formats, schema, auth boundaries, CI/CD, and dependency upgrades are high-risk; assess blast radius first.
- Medium or large implementation should run from an approved plan or reviewed execution packet, with evidence, peer review, and verification before closure.
- Spec/tasks should be parallel-ready when possible: include owner lane, reviewer lane, dependencies, write set, parallel group, acceptance checks, TDD or minimal reproducible check, verification command, and stop conditions.
- Code changes follow SDD then TDD: reviewed design/task boundary first, then failing test or reproducible check before implementation when practical.
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

- `senior-project-expert`: compatibility skill used when a runtime resolves the Senior Project Expert request as a skill instead of the Senior Project Expert agent; it still runs the mandatory init preflight before substantive target-repository work.
- `repo-init-gate`: read only the target root `best-copilot.md` and decide whether full init is needed.
- `repo-init-scan`: use only after `repo-init-gate` fails; typical triggers are first substantial task, missing scaffolds, missing or placeholder `.github/instructions/project.instructions.md`, missing or mismatched `best-copilot.md`, or incomplete `/init` output.
- `repo-init-official`: try official `/init` or `copilot init` and normalize the resulting project facts file.
- `repo-init-manual-fallback`: do the bounded manual scan, bootstrap missing scaffolds, verify required artifacts, and write `best-copilot.md`.
- `target-instructions-bootstrap`: create missing `.github/instructions/**`, optional `AGENTS.md`, and Claude Code `CLAUDE.md` when applicable.
- `target-memory-bootstrap`: create missing `memories/repo/**` skeleton.
- `target-spec-bootstrap`: create missing `spec/**` skeleton and spec templates.

## Planning And Execution

- `core-workflow-contract`: shared cross-role source priority, runtime adapters, init gates, dispatch packet shape, review/verification, memory/spec, and closeout rules.
- Role workflow skills: load one matching the active agent role together with `core-workflow-contract`; direct specialist use also needs current init-gate evidence or must run `repo-init-gate` first.
  - `senior-project-expert-workflow`: PM/coordinator scope, routing, dispatch, fan-in, closeout, and evolution signals.
  - `specification-writer-workflow`: requirements, design, tasks, ADRs, closeout records, and memory/spec recovery.
  - `technical-architect-workflow`: full-stack architecture, SDD design brainstorming, service boundaries, data/API contracts, blast radius, mainline implementation, parallel decomposition, and cross-review.
  - `developer-workflow`: frozen implementation slices, scoped peer review, `NEEDS_CONTEXT` / `NEEDS_USER_INPUT`, and verification evidence.
  - `frontend-designer-workflow`: UI implementation/review, design-system reuse, responsive/browser evidence, and visual quality.
  - `quality-assurance-workflow`: functional verification, regression risk, test sufficiency, and merge-readiness review.
  - `security-reviewer-workflow`: auth, permissions, dependencies, secrets, release surfaces, and sensitive data review.
  - `root-cause-fixer-workflow`: concrete failure evidence, minimal root-cause patching, and regression proof.
- `brainstorming`: ambiguous MEDIUM/LARGE direction before spec or code; in PM-led large technical work, route deep design brainstorming through Technical Architect.
- `writing-plans`: confirmed MEDIUM/LARGE direction into executable tasks.
- `spec-review-gauntlet`: pre-implementation readiness and multi-lane design review for Spec Bundles and execution plans.
- `executing-plans`: approved tasks.md or multi-step plan execution with checkpoints, verification evidence, and per-task review.
- `subagent-driven-development`: fresh-context specialist execution for approved plans, requiring implementation, spec-compliance review, code-quality review, and verification per task.
- `spec-execution-fastpath`: clear requirement or spec with minimal diff.
- `workspace-isolation`: before approved implementation or substantial feature/fix work when branch/worktree isolation, provenance, or baseline setup must be decided.
- `test-driven-development`: new behavior or bug fix where a focused failing test is practical.
- `systematic-debugging`: unknown root cause or failing behavior.
- `root-cause-investigation`: failure evidence exists and scope is narrow.

## Context And Review

- `search-fastpath`: target files are unclear or search is becoming expensive.
- `context-packet-fastpath`: prepare or consume a minimal dispatch/context packet.
- `change-verification`: prove changed behavior after edits.
- `verification-before-completion`: final evidence check before closeout.
- `development-branch-closeout`: final branch/worktree decision after verification evidence exists.
- `structured-review`: review code, customization, design, review handoff, feedback intake, and targeted re-review.

## Claude Code Skill Names

After installing this plugin in Claude Code, invoke plugin skills with namespaced slash commands, for example `/best-copilot:repo-init-gate`, `/best-copilot:repo-init-scan`, `/best-copilot:structured-review`, and `/best-copilot:verification-before-completion`. If the command picker inserts another displayed plugin form, use that exact picker value. For a Senior-owned main session, start Claude Code with `--agent senior-project-expert` or set `.claude/settings.json` / user settings with `"agent": "senior-project-expert"`; if Claude reports a name collision, use scoped `best-copilot:senior-project-expert`. The PM coordinator dispatches plugin subagents via the Agent tool using the names displayed by `/agents`, which for plugin agents are scoped names such as `best-copilot:technical-architect` and `best-copilot:developer`. Manual `@` mentions should use the scoped typeahead value, for example `@"best-copilot:senior-project-expert (agent)"` or manual `@agent-best-copilot:senior-project-expert`. Do not depend on a plain-text prompt mention as a stable first-use or dispatch path. If the Senior Project Expert request is resolved as `Skill(senior-project-expert)` or `Skill(best-copilot:senior-project-expert)`, use that compatibility skill only as a PM entrypoint; it must run the same init preflight before analysis, planning, dispatch, or implementation. If a specialist such as `best-copilot:technical-architect` or `best-copilot:developer` is invoked directly, it must receive current init evidence from PM or run `/best-copilot:repo-init-gate` itself before target-repository exploration.
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
- When running under Claude Code, use plugin skills as namespaced slash commands such as `/best-copilot:repo-init-gate`; if the picker inserts another displayed plugin form, use that exact value. PM dispatches plugin subagents via the Agent tool using scoped names shown in `/agents`, such as `best-copilot:technical-architect`. For a Senior-owned main session, use `--agent senior-project-expert` or the Claude `agent` setting; if there is an agent-name collision, use `best-copilot:senior-project-expert`. If the Senior name is resolved as a skill, its compatibility skill still starts with the repo init preflight. Direct specialist use needs current init evidence or must run `/best-copilot:repo-init-gate` first.
```

## `CLAUDE.md`

```markdown
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
- Use plugin skills as namespaced slash commands such as `/best-copilot:repo-init-gate`, `/best-copilot:structured-review`, `/best-copilot:verification-before-completion`, unless the picker inserts another displayed plugin form.
- Keep this file short. Add project facts to `.github/instructions/project.instructions.md`, durable recovery state to `memories/repo/**`, and task specs to `spec/**`.
```

## `.claude/settings.json`

Create this file only for Claude Code target compatibility when it is absent. If the file already exists, preserve existing settings and add only the missing top-level `agent` key and missing `worktree.baseRef` value when safe.

```json
{
  "agent": "senior-project-expert",
  "worktree": {
    "baseRef": "head"
  }
}
```

This makes the PM coordinator (`senior-project-expert`) the default session entry and keeps Claude Code isolated worktrees aligned with the current branch `HEAD`. The PM then dispatches to specialist subagents via the Agent tool and owns worktree closeout.

## Verification

- Confirm generated files exist in the target repository.
- path existence alone is not enough; required sections must also be present after create or repair.
- Confirm existing files were not overwritten.
- Confirm `.github/instructions/must.instructions.md` contains `## Request Flow` with the per-request timestamp rule, init normalization rule, and packet freeze rule.
- Confirm `.github/instructions/must.instructions.md` contains `## Per-Request Hard Gates`, `### No Silent Closeout`, all native-closeout bullets from this skill, the instruction-only closeout-backstop rule, the VS Code `vscode_askQuestions` exact-tool priority, and the specialist `NEEDS_USER_INPUT`/`BLOCKED missing_top_level_question` rule.
- Confirm `.github/instructions/must.instructions.md` contains `### PM Native Ask Trigger Gate`, including the rule that brainstorming is not the only native ask trigger, the rule that PM/coordinator frontmatter ask tools are an availability signal, and the custom free-form native ask path.
- Confirm `.github/instructions/must.instructions.md` contains `## Shared State Contracts` with `work_mode`, `task_type`, and `pm_action`.
- Confirm `.github/instructions/must.instructions.md` contains `### Fan-In Arbitration`.
- Confirm `.github/instructions/must.instructions.md` contains `## Search Precision` and the fixed-string-before-regex rule.
- Confirm `.github/instructions/must.instructions.md` contains `## Command Output Budget` and the default `COMMAND 2>&1 | head -c 4000` pattern.
- Confirm `.github/instructions/must.instructions.md` contains the first-use scaffold gate that names `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- Confirm `.github/instructions/must.instructions.md` contains the progressive-disclosure memory rule, the mixed-language rule, `## Agents and Dispatch`, cross-review lanes, Technical Architect-led SDD design review, and `## Implementation and Verification`.
- Confirm `.github/instructions/skills-index.instructions.md` contains the Claude Code skill-name note when that file exists.
- When Claude Code compatibility is required, confirm `CLAUDE.md` exists and references `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, and `.github/instructions/skills-index.instructions.md`.
- When Claude Code compatibility is required, confirm `CLAUDE.md` mentions the PM coordinator dispatch model (Agent tool for specialist subagents), foreground/background dispatch policy, isolated worktree closeout, namespaced plugin skill commands, scoped `/agents` / `@` names for plugin subagents, and the unscoped `--agent senior-project-expert` first-use path with scoped fallback for collisions.
- When a stable Claude Code PM entry is required, confirm `.claude/settings.json` exists, is valid JSON, contains `"agent": "senior-project-expert"`, and contains `"worktree": {"baseRef": "head"}` unless an existing explicit worktree policy was preserved.
- Confirm no generated file contains unresolved project-specific claims, secrets, or plugin-cache paths.
- If this skill was invoked because `.github/instructions/**` or a required runtime adapter was missing and the required files still do not exist after the attempt, return `BLOCKED target_instructions_bootstrap_incomplete` with the missing paths. Do not let the caller continue the substantive task as if initialization succeeded.
