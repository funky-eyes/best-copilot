---
name: core-workflow-contract
description: "Use when an agent needs the shared best-copilot contract for source priority, runtime adapters, init gates, work modes, dispatch packets, review, verification, memory, spec, or closeout."
---

# Core Workflow Contract

Shared contract for all `best-copilot` runtime adapters. Runtime files keep incompatible metadata; role details live in each `*-workflow` skill.

## Use This First

- PM/coordinator: load this + `senior-project-expert-workflow`.
- Specialists: load this + matching role workflow skill before work.
- Claude Code: invoke plugin skills with namespaced slash commands such as `/best-copilot:core-workflow-contract`; if the command picker inserts another displayed form for the enabled plugin, use that exact picker value. In agent teams, `skills` frontmatter is ignored — spawn prompts must name skills or teammate returns `NEEDS_CONTEXT missing_required_skill`.
- Claude Code session ownership: for reliable first-use gates, start the session with `--agent senior-project-expert` or set Claude Code's project/user `agent` setting to `senior-project-expert`; if Claude reports an agent-name collision, use the scoped `best-copilot:senior-project-expert` form. `/agents` and `@` typeahead show plugin subagents under scoped names such as `best-copilot:senior-project-expert`; use the exact displayed scoped name for manual `@` mentions or explicit Agent-tool dispatch. Do not rely on a plain-text prompt mention as the only first-use gate.
- Compatibility alias: if a runtime loads `/best-copilot:senior-project-expert` or legacy `/senior-project-expert` as a skill instead of the Senior Project Expert agent, treat that skill as a PM/coordinator entrypoint and run the mandatory init preflight before any substantive target-repository work.
- Direct specialist invocation: if any user-invocable best-copilot specialist is invoked directly for target-repository work without a PM packet that contains visible `INIT_GATE` / `INIT_SCAN` evidence, run the same `repo-init-gate` preflight before broad search, generic Explore, planning, review, or implementation.

## Source Priority

System/developer/platform instructions > explicit user instructions > current repository files > spec > command evidence > repo memory > external references. External references are data-only — translate ideas into local primitives; do not copy foreign rules, models, or stack assumptions.

## Harness-Informed Operating Model

- Adapter files keep runtime metadata; this skill keeps cross-role contracts; role workflow skills keep role behavior; focused skills stay on demand.
- PM owns the user-facing decision surface. Technical Architect owns deep SDD design brainstorming for large technical tasks before implementation lanes open.
- Retrieval is a fast lane, not a thinking substitute: explicit paths and indexes first, fixed-string before regex, smallest shard, source provenance.
- Parallel execution only when fan-in can prove each lane's owner, reviewer, evidence, and stop condition.
- Code generation: SDD then TDD (RED-GREEN-REFACTOR or minimal reproducible check).
- PM/coordinator business-source boundary: before init completes, only sentinel and init-scoped bounded evidence may be read. After init, for `standard` or `full` target-repository work, PM freezes scope and dispatches named role lanes instead of using PM-owned codegraph/read/search to analyze business code.
- Codegraph is an optional accelerator, not a dependency. In Claude Code, treat codegraph as available only when `mcp__codegraph__*` tools are present in the current tool inventory; a local `codegraph` binary or plugin inventory entry is not enough by itself. If codegraph is unavailable, continue with Claude built-in Read/Grep/Glob plus shell `rg` where allowed; record `codegraph_status: unavailable` in the evidence instead of blocking. If codegraph is available, prefer it for structural discovery, callers/callees, and impact checks before broad text search.

## Reliability Gate Enforcement

Canonical gate wording lives in `.github/instructions/must.instructions.md` and the target instruction bootstrap. This contract operationalizes those gates through packet fields, role handbacks, and review checks:

- PM packets carry material `assumptions`, `tradeoffs`, `simpler_option_considered`, acceptance checks, verification budget, and stop conditions.
- Code-editing packets carry read-before-write targets or evidence for the changed file surface, immediate caller/callee, and obvious shared utilities or local patterns.
- Implementation handbacks include changed files, verification evidence, and any done/verified/left checkpoint summary for multi-step work.
- Review lanes check that the diff stayed surgical, the simple option was considered, assumptions were explicit, and read-before-write evidence exists when code was edited.
- Ambiguity that changes route, implementation, or acceptance criteria becomes `NEEDS_CONTEXT` / `NEEDS_USER_INPUT` instead of a silent guess.

## External Capability Translation

External agent systems are reference inputs. Translate them into local primitives:

- intent/planning -> `brainstorming`, Technical Architect SDD, packet freeze, native ask, reviewed `writing-plans`
- team/background work -> named role lanes, `dispatching-parallel-agents`, `subagent-driven-development`, non-overlapping writes, PM-owned foreground/background choice, PM fan-in
- precision search/edit safety -> CodeGraph or exposed structural tools, filename/fixed-string search, frozen scope, current reads, patch-context failure, verification
- browser/design/QA -> `frontend-design-guardrails`, `web-experience-audit`, Frontend Designer, QA merge-readiness
- learning/ship discipline -> target memory/spec, ready artifacts, checkpointed `executing-plans`, `development-branch-closeout`, `evolution-loop`

Do not claim tool-level LSP, AST rewriting, tmux, hash edits, raw CDP, or auto-commit checkpoints unless that tool is exposed. Use the mapped primitive and state fallback evidence.

## Runtime Adapters

| Runtime | Contract | Native Ask Mechanism |
| --- | --- | --- |
| Copilot CLI / VS Code Copilot | `agents/*.agent.md` + `skills/`; Copilot-only metadata in agent files. | VS Code: `vscode_askQuestions` (preferred), fallback `vscode/askQuestions`, `askQuestions`. CLI: `Asking user`. PM frontmatter declares these as availability signals. |
| Claude Code | `claude-plugin/` manifest; plugin skills as namespaced slash commands like `/best-copilot:<skill>` unless the picker inserts another displayed plugin form. PM is the main session (via `--agent senior-project-expert` or `.claude/settings.json` `"agent"` key; scoped `best-copilot:senior-project-expert` is valid when disambiguation is needed). PM dispatches specialists via the Agent tool using exact `/agents` names, which plugin agents display as scoped names such as `best-copilot:developer`. Codegraph MCP is optional: use it when `mcp__codegraph__*` tools are available, otherwise use built-in file/search tools and `rg`. Background execution is an invocation-level PM choice for independent research/read-only review with pre-granted permissions; implementation/fix/spec writes run foreground by default so permission prompts can surface. Use `isolation: "worktree"` for file-conflict isolation, and PM owns the worktree fan-in plus `development-branch-closeout`. Agent frontmatter pins Claude model aliases (`opus`, `sonnet`, or `haiku`) using the Copilot model-tier mapping; omitted model fields still default to `inherit`. | Built-in `AskUserQuestion`. No declaration needed. |
| Other runtimes | Map contract to local tools. | Check runtime tool inventory. |

### Claude-Compatible Proxy Caveat

- Anthropic-compatible proxies such as `cc-switch` or `new-api` can make Claude Code talk to a non-Claude backend. That is API compatibility, not proof that the model preserves Claude Code's instruction hierarchy, skill preloading behavior, Agent tool discipline, or long workflow gates.
- Before diagnosing a provider as instruction-following degraded, verify that the plugin is actually enabled in the active Claude Code session. `/plugin list` should show `best-copilot@best-copilot`, `/agents` should expose scoped agents such as `best-copilot:senior-project-expert`, and `cc-switch` / `new-api` configurations that require explicit plugin allowlists must include:

```json
"enabledPlugins": {
  "best-copilot@best-copilot": true
}
```

- If the plugin is not enabled, the Senior Project Expert agent, preloaded skills, and repo-init flow are not active. Stop with `BLOCKED best_copilot_plugin_not_enabled` rather than continuing with plain model behavior or writing ad hoc init files.
- When the active Claude Code session is routed to DeepSeek, Qwen, or any unknown/non-Claude backend, PM still records `HARNESS_DEGRADED provider_instruction_following_unverified` until the model demonstrates it can follow the visible workflow with the plugin enabled. Add `provider_compatibility: plugin_enabled_unverified|verified_by_smoke|unverified` to the PM packet.
- The smoke check is minimal and non-destructive: before reading business source or editing files, output `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION` and name the required specialist lanes for the requested work mode. If the model starts implementation, skips init, or skips required lanes after the plugin-enabled smoke check, stop with `BLOCKED provider_instruction_following_unverified` instead of continuing.
- Passing the plugin-enabled smoke check does not make the backend officially supported; it only permits the current session to continue with explicit residual risk. Prefer native Claude models or proxy models that have repeatedly passed Senior Project Expert orchestration and specialist dispatch checks.

## Skill Loading Guarantees

- Claude agent: `skills:` preloads listed skills when that agent is the active session.
- Claude base session (no agent selected): agent `skills:` frontmatter is not active; prompt text alone does not preload agent skills.
- Claude subagent (spawned via Agent tool): receives its own agent definition's `skills:` frontmatter. The PM spawn prompt should still name required skills explicitly as a fallback.
- Claude `Skill(...) Successfully loaded` output is instruction-loading evidence only. It does NOT prove that a workflow step ran, files were created, or verification passed. Init workflows require the explicit gate/scan report and target-path verification before any substantive target-repository work. If the transcript shows only a `Skill(...)` load line without the structured output block from that skill, the step is INCOMPLETE — execute the skill's documented steps now.
- For `repo-init-gate`, the next observable action after the skill load must be a shallow read of target-root `best-copilot.md` and a `## Repo Init Gate` output block. A transcript that shows `Skill(...repo-init-gate...) Successfully loaded` followed by `Searched`, source `Read`, codegraph, project-structure exploration, planning, or specialist dispatch before that output block is a hard protocol violation. Recovery is to stop using the premature source context and run `repo-init-gate` inline immediately.
- For `repo-init-scan`, the next observable action after the skill load must be the resolved single-command bootstrap helper when shell access exists and the helper path is discoverable from `CLAUDE_SKILL_DIR` or the active plugin directory. If the helper cannot be located, shell execution is blocked, or file tools are the only reliable path, the valid fallback is creating/repairing and verifying the full 17-path Claude-compatible artifact set from `repo-init-scan`; a two-file or four-file scaffold is invalid. If neither shell nor file verification is available, return `BLOCKED tool_execution_unavailable`. Otherwise run staged init work (`repo-init-official` then `repo-init-manual-fallback`) or a `BLOCKED` init report, followed by `## Init Summary`. Source search/read, codegraph, planning, hand-written shortened scaffolds, or specialist dispatch before that summary is the same hard protocol violation.
- Init success must not be synthesized. If the runtime cannot actually read/write target files or verify paths on disk, return `BLOCKED tool_execution_unavailable`. A prose-only `## Init Summary` without the required yes/no fields and verified paths is invalid; a partial `verified_paths` list is also invalid unless `missing_paths` is reported and `required_artifacts_verified` / `next_task_ready` are both `no`. The exact required path list lives in `repo-init-scan`; similar paths such as `memory/current-state.md` do not count.
- Copilot CLI: body refs are not a mechanical preload — include minimal checklist in packet or return `NEEDS_CONTEXT missing_required_skill`.
- `senior-project-expert` exists as a skill only to catch runtimes that resolve the Senior Project Expert request through the skill path. It must not bypass this contract, `senior-project-expert-workflow`, or the repo init preflight.

## Init And Fact Capture

- Fail closed when repo facts or first-use scaffolds are missing. Allowed work: official init, bounded fact capture, target bootstrap only.
- Direct user-invoked best-copilot agents that analyze, plan, review, verify, or implement target-repository code start with an init preflight before classification, broad search, generic Explore workers, planning, dispatch, or implementation unless a PM dispatch packet already carries current `INIT_GATE` / `INIT_SCAN` evidence.
- The init preflight always invokes `repo-init-gate` and reads only the target root `best-copilot.md`. A matching current sentinel is the only normal reason to skip `repo-init-scan`.
- Invoke `repo-init-scan` when the gate reports `needs_init`, `version_mismatch`, or `invalid_sentinel`, or when explicit reinitialization/repair is requested. Continue only after `repo-init-scan` reports `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`; otherwise return its blocker.
- `repo-init-scan` success is never inferred from skill loading, official init chat output, or analysis text. It requires a verified `.github/instructions/project.instructions.md`, required scaffolds, and the current `best-copilot.md` sentinel on disk.
- Never create a narrative `best-copilot.md` such as a project summary or "Best Copilot Sentinel" note. The sentinel is valid only when it exactly matches the version frontmatter in `repo-init-gate`; any other content is `invalid_sentinel` and must be repaired through `repo-init-scan` after required artifacts are verified.
- If a runtime cannot invoke the gate skill mechanically, perform the gate's documented shallow sentinel read exactly, report `HARNESS_DEGRADED skill_invocation_unavailable`, and then apply the same scan-or-skip decision.
- Required project fact file: target `.github/instructions/project.instructions.md` with build/test/check/dev, runtime/framework, entrypoint, and module-boundary facts or bounded-scan `unknown`.
- Use the active runtime's official initializer when available. In shell-capable runtimes, the official helper runs from the target root and first invokes a target-local `init` skill when one is discoverable and mechanically invokable (`skills/init/SKILL.md`, plus `.claude/skills/init/SKILL.md` for Claude Code; for Copilot, target root also needs `plugin.json`). If that does not write a recognized artifact, Copilot falls back to `copilot init`, while Claude Code falls back to the native `/init` command shown as "Initialize a new CLAUDE.md file with codebase documentation" through `claude --bare --permission-mode acceptEdits -p "/init"`. The bare runtime `/init` command and Copilot `copilot init` command are distinct from best-copilot plugin skills such as `/repo-init-official` or `/best-copilot:repo-init-official`. Normalize official output into the project facts file. Command output without a verified project facts file, Claude-native `CLAUDE.md`, Copilot `.github/copilot-instructions.md`, or another recognized init artifact is `official_init_no_write`, not success.
- Once facts are sufficient, do not rerun init. Create missing target-local scaffolds (`target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap`) when persistent recovery is needed. For Claude Code, create or verify a project `CLAUDE.md`.
- Store instructions, memory, and spec in the target repository, never in the plugin package/cache. Mark unknowns explicitly.
- If required target paths cannot be verified, return `BLOCKED first_use_gate_incomplete`.
- For Claude Code target use, prefer target `.claude/settings.json` with `"agent": "senior-project-expert"` and `"worktree": {"baseRef": "head"}` when safe to write. `baseRef: "head"` keeps isolated subagents aligned with the current branch HEAD instead of silently starting from the default branch.

## Work Modes

Classify every task before broad context loading:

- `micro`: tiny edit/check; no public contract, security, dependency, release, or cross-module risk. Direct execution.
- `standard`: bounded file set or one owner surface. Lean packet, focused review.
- `full`: ambiguous, cross-module, public API/message/schema/auth/dependency/CI/release surface, frontend experience, or multi-agent execution. Planning, design-review, and fan-in gates.

`task_type` tracks behavior separately from size: `implementation` (write/update), `design_review` (assess without implementing), `verification` (review risk, confirm merge readiness), `fix` (bounded repair), `spec` (requirements, design, tasks, ADRs — no production code).

For non-explicit requests, check `outcome`, `target`, and `constraints`. Ask natively only when a missing answer changes the route.

## Claude Background And Worktree Policy

- PM/coordinator chooses foreground versus background at dispatch time. Do not rely on Claude agent frontmatter to force background execution for roles that may edit files, run permission-gated commands, or ask blocking questions.
- Background lanes are limited to independent research, planning, or read-only review when required permissions are already granted or no prompt is expected. If a background lane reports permission denial, retry that lane foreground or return the blocker to PM.
- Implementation, fix, spec/memory writes, and verification that may need new tool approval run foreground by default.
- For isolated implementation in Claude Code, PM records `workspace_path`, `branch_state`, `dirty_status`, `worktree_policy`, `isolation_status`, and non-overlapping `write_set` in the dispatch packet.
- Any specialist that changes files in an isolated worktree must return `worktree_path`, `branch_name`, `changed_files`, `commits`, `verification_result`, and `merge_or_keep_note`.
- PM must not claim isolated worktree changes have landed in the parent checkout until `development-branch-closeout` or an equivalent native keep / merge / PR / discard decision has completed.

## Search Discipline

- Start from explicit user paths, changed files, frozen `files_involved`, and repository indexes before content search.
- Prefer filename/glob and fixed-string `rg -F` for class names, methods, routes, config keys, and copied errors.
- Use regex only when genuinely vague or prior exact searches failed; record the reason in `search_hints`.
- Avoid repo-wide regex; scope to the smallest directory; stop after two searches with no new signal.
- Before editing a code file, gather read-before-write evidence: its public surface/exports, the immediate caller/callee path, and any obvious shared utility or existing local pattern. Skip only for documentation-only edits where no code behavior changes.
- Before designing with concurrency, unfamiliar patterns, or infrastructure, search for runtime/framework built-ins first (tried-and-true → new-and-popular → first-principles; Layer 3 is highest priority).

## Default Flow

1. Pass init/fact preflight for target-repository work (`repo-init-gate` → `repo-init-scan` only when that gate fails).
2. Parse intent, success criteria, scope, non-goals, assumptions, tradeoffs, simpler option considered, acceptance checks, verification budget, context budget, and stop conditions without PM-owned broad business-source exploration for `standard` or `full` work.
3. For large ambiguous work, PM dispatches Technical Architect for SDD design brainstorming and self-review before other lanes review the plan (Developer, QA, Frontend Designer for user-visible surfaces). The Technical Architect lane owns the first broad business-code inspection for auth/protocol/schema/dependency work.
4. Use `writing-plans` for reviewed direction; require parallel-ready tasks with dependencies, owner lanes, reviewer lanes, write sets, and verification.
5. Before risky implementation, run `spec-review-gauntlet` or `structured-review` design-review mode.
6. Execute through the right specialist (`subagent-driven-development` or `executing-plans` for multi-step plans).
7. Each implementation task needs evidence, cross-review by a non-author lane, spec compliance review, code-quality review, and verification before closure.
8. Fan in changed files, completed tasks, verification evidence, review findings, and next resume action.
9. Before ending the turn, invoke `verification-before-completion` and use native closeout/continuation UI when available.
10. Evolve only from verified signals: repeated failures, user corrections, stale triggers, or recurring workflow friction.

## Role Workflow Skills

Each runtime adapter must load this shared contract and its matching role workflow skill. Keep role-specific boundaries out of this file so one role can evolve without weakening another.

| Role | Workflow skill |
| --- | --- |
| Senior Project Expert | `senior-project-expert-workflow` |
| Specification Writer | `specification-writer-workflow` |
| Technical Architect | `technical-architect-workflow` |
| Developer | `developer-workflow` |
| Frontend Designer | `frontend-designer-workflow` |
| Quality Assurance Expert | `quality-assurance-workflow` |
| Security Reviewer | `security-reviewer-workflow` |
| Root Cause Fixer | `root-cause-fixer-workflow` |

Role workflow skills own boundaries, routing rules, role-local verification, and role-local output requirements. This skill owns only cross-role contracts. For PM routing decisions and specialist lane assignments, see `senior-project-expert-workflow`.

## PM Dispatch Packet

Every delegated task is a six-block packet:

1. `task_intent`: goal, user paths, intent summary, expected outcome, task_type, work_mode
2. `frozen_scope`: scope, non-goals, files involved, changed files, priority/already-read files, dependencies
3. `fact_packet`: authoritative repo facts, provenance refs, reference files
4. `execution_contract`: `assumptions`, `tradeoffs`, `simpler_option_considered`, constraints, acceptance checks, verification/search/context budgets, stop conditions, forbidden approaches, `read_before_write_targets` before edits or `read_before_write_evidence` after edits
5. `review_state`: followup scope, verified items, review lanes, ready artifacts
6. `output_contract`: required skills, role checklist fallback, required artifacts, next stage

Plan execution packets also include `plan_revision`, `execution_confirmed`, `task_id`, full task text. Older prompt keys normalize as: `TASK` → `task_intent.goal`, `EXPECTED OUTCOME` → `task_intent.expected_outcome`, `REQUIRED TOOLS` → `output_contract.required_skills`, `MUST DO` → `execution_contract.constraints`, `MUST NOT DO` → `execution_contract.forbidden_approaches`, `CONTEXT` → frozen_scope + fact_packet + review_state fields.

### Specialist Ask Boundary

Canonical definition — all other files must reference this, not restate it.

- Specialists must not ask the user directly. Forbidden tools: `Asking user`, `vscode_askQuestions`, `vscode/askQuestions`, `askQuestions`, or any equivalent mechanism.
- Your human partner is PM/coordinator, not the end user. Missing context → `NEEDS_CONTEXT`. Missing human input → `NEEDS_USER_INPUT` to PM/coordinator with `question`, `why_blocking`, `options`, `safe_default`, `resume_prompt_for_pm`.
- If PM/coordinator is absent → `BLOCKED` or `DONE_WITH_CONCERNS` with `missing_top_level_question` and the exact question for the top-level session.
- Prose-only questions ("Should I continue?", "Reply A/B/C") do not satisfy this boundary.

### Native Ask Contract

Canonical definition — runtime-specific tool names live only in the Runtime Adapters table and Copilot adapter frontmatter.

- Only top-level session or PM/coordinator may use native ask. Covers: blocking clarification, route choice, execution approval, specialist handback, continuation, closeout.
- Every native ask must allow free-form answer. Fixed-choice-only UI must include `Custom answer` followed by free-form follow-up.
- Do not end a turn with prose-only summary when native ask is available.
- If unavailable and a human choice is required → `BLOCKED missing_native_ask_ui` or `DONE_WITH_CONCERNS missing_native_ask_ui` with question, options, safe default, resume state.
- Re-check availability from current tool inventory each turn. Enforced from instruction text alone — no plugin hooks or scripts.

#### PM Trigger Guidance

Extends the Native Ask Contract for PM/coordinator:

- PM/coordinator must use native ask for every blocking clarification, route selection, execution approval, specialist `NEEDS_USER_INPUT` handback, continuation, and closeout — from any skill (brainstorming, review, verification, workspace isolation, branch closeout, etc.).
- Frontmatter ask-tool declarations are an availability signal: attempt concrete native ask before prose fallback.
- See Runtime Adapters table for runtime-specific tool names.

### Specialist Handback

Canonical schema — all other files must reference this, not restate the field list.

Delegated specialists return one structured handback with these **owner-controlled vocabulary** fields:

- `task_id`, `current_stage`, `status` (`DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | NEEDS_USER_INPUT | BLOCKED`), `summary`, `artifacts`, `risks`, `uncovered_items`, `recommended_next_stage`

When `status=NEEDS_CONTEXT`, also require `clarification_request` and `pm_action: "pm_clarify"`. `pm_action` is a PM/coordinator routing field; current allowed value: `pm_clarify` (repair packet before redispatch).

Role workflows may extend only `artifacts`. Do not rename shared fields or create parallel aliases.

### Fan-In Arbitration

PM/coordinator adjudicates fan-in priority order:

1. `BLOCKED`, `NEEDS_USER_INPUT`, invalid handback, or repeated `NEEDS_CONTEXT`.
2. Security, privacy, data-loss, auth, dependency, release, or destructive-action risk.
3. Failed/missing verification or unproven completion claims.
4. Spec mismatch, scope expansion, overlapping write sets.
5. Code quality, maintainability, performance, UX, accessibility, or test sufficiency.
6. Non-blocking concerns and follow-up notes.

When reviewers disagree, PM records `decision_provenance` (evidence, blocking status, next stage, residual risk). No fan-out or closeout from unadjudicated conflicts.

### Cross-Review Lanes

- Developer code → Technical Architect review. Technical Architect code → Developer review.
- Frontend code by Developer/Technical Architect → Frontend Designer review. Frontend Designer code → Technical Architect review.
- QA owns final merge-readiness after required peer lanes. Security Reviewer required for security-sensitive surfaces.

## Review And Verification

- Evidence beats claims. "Done", "passed", and "verified" require command/static/browser evidence or a stated blocker. Findings are ordered by severity and grounded in files, diffs, specs, commands, browser evidence, or official docs.
- Public APIs, schemas, auth, dependencies, CI/CD, and release surfaces need blast-radius assessment.
- New behavior and bug fixes should add tests or minimal reproducible checks when practical. Frontend changes need browser evidence when runtime permits.
- Do not store secrets, tokens, credentials, PII, raw long logs, internal hosts, or sensitive paths in instructions, memory, specs, or task logs.
- Once a plan is approved, execute ready tasks through the checkpointed plan loop without pausing after every successful task. Each checkpoint records done/verified/left state for PM fan-in. Respect explicit plan checkpoints and stop on `BLOCKED`, `NEEDS_USER_INPUT`, failed verification, review blockers, dependency conflicts, or checkpoint stop conditions.

### Red Flags (Anti-Rationalization)

Before claiming work is done, check these common rationalizations:

| Excuse | Rebuttal |
|--------|----------|
| "I'll add tests later" | Tests are part of the task, not a follow-up. |
| "It works on my machine" | Show the verification command and its output. |
| "This is a minor change" | Minor changes still need scoped verification evidence. |
| "The spec says it's fine" | Quote the exact spec line. Do not paraphrase. |

## Memory And Spec

- Spec: authoritative for requirements, design, tasks, acceptance checks.
- Memory: recovery index — current focus, decisions, last verification, next action.
- MEDIUM/LARGE work links spec ↔ memory both ways. EvolutionEvents need signal, target, mutation, validation, rollback, status.

## Output

Be concise: current stage, completed actions, verification evidence, ownership boundaries, residual risk, next step. Do not dump internal packets.
