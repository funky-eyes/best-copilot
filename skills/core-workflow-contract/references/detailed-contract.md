# Detailed Contract Reference

Load this file only when the compact `SKILL.md` is not enough for routing, runtime, or prompt details.

## Runtime Adapters

| Runtime | Contract | Native Ask |
| --- | --- | --- |
| Copilot CLI / VS Code Copilot | `agents/*.agent.md` + `skills/`; Copilot-only metadata stays in agent files. | VS Code: `vscode_askQuestions`, then `vscode/askQuestions`, then `askQuestions`. CLI: `Asking user`. |
| Claude Code | `claude-plugin/` manifest; skills as `/best-copilot:<skill>` unless picker inserts another displayed form. PM session starts with `--agent senior-project-expert` or project/user `"agent": "senior-project-expert"`, scoped fallback `best-copilot:senior-project-expert`. PM dispatches scoped `/agents` names such as `best-copilot:developer`. | Built-in `AskUserQuestion`. |
| Other runtimes | Map to local tools. | Check current tool inventory. |

## Claude Provider Caveat

For `cc-switch`, `new-api`, DeepSeek, Qwen, or unknown backends:

- Verify plugin enablement before target work.
- `/plugin list` should show `best-copilot@best-copilot`.
- `/agents` should expose scoped plugin agents.
- Allowlist configs that need plugin enablement must include `"enabledPlugins": {"best-copilot@best-copilot": true}`.
- If not enabled, return `BLOCKED best_copilot_plugin_not_enabled`.
- If enabled but model behavior is unverified, record `provider_compatibility` and run the visible smoke trail: `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION`.
- If the model skips init, required lanes, or starts implementation early, stop with `BLOCKED provider_instruction_following_unverified`.

## PM Dispatch Packet

Every delegated task uses six blocks:

1. `task_intent`: goal, user paths, intent summary, expected outcome, task type, work mode, response language.
2. `frozen_scope`: scope, non-goals, files involved, changed files, priority/already-read files, dependencies.
3. `fact_packet`: authoritative repo facts, provenance refs, reference files.
4. `execution_contract`: assumptions, tradeoffs, simpler option considered, constraints, acceptance checks, verification/search/context budgets, stop conditions, forbidden approaches, read-before-write targets or evidence.
5. `review_state`: followup scope, verified items, review lanes, ready artifacts.
6. `output_contract`: required skills, role checklist fallback, required artifacts, next stage, state sync requirements.

Plan execution packets also include `plan_revision`, `execution_confirmed`, `task_id`, and full task text.

## Specialist Ask Boundary

- Specialists must not use user-facing ask tools.
- Missing PM packet facts -> `NEEDS_CONTEXT`.
- Missing human decision -> `NEEDS_USER_INPUT` to PM/coordinator with `question`, `why_blocking`, `options`, `safe_default`, and `resume_prompt_for_pm`.
- No PM present -> `BLOCKED` or `DONE_WITH_CONCERNS` with `missing_top_level_question`.

## Native Ask Contract

- Only top-level session or PM/coordinator uses native ask.
- Applies to blocking clarification, route choice, execution approval, specialist handback, continuation, and closeout.
- Preserve a free-form answer path. Fixed-choice-only UI must include `Custom answer` and then a free-form follow-up.
- If unavailable and a human choice is required, return `BLOCKED missing_native_ask_ui` or `DONE_WITH_CONCERNS missing_native_ask_ui` with question, options, safe default, and resume state.

### Claude Code `AskUserQuestion`

- Use one question by default.
- `header` is 12 characters or fewer.
- Provide 2-4 options with short descriptions.
- Use `multiSelect: false` unless multi-select is explicitly required.
- Treat selected labels and custom text as new user instructions.

## Fan-In Arbitration

PM adjudicates in this order:

1. `BLOCKED`, `NEEDS_USER_INPUT`, invalid handback, repeated `NEEDS_CONTEXT`.
2. Security, privacy, data-loss, auth, dependency, release, or destructive-action risk.
3. Failed or missing verification.
4. Spec mismatch, scope expansion, overlapping write sets.
5. Code quality, maintainability, performance, UX, accessibility, or test sufficiency.
6. Non-blocking concerns and follow-up notes.

Record `decision_provenance` for conflicts or overruled concerns.

## Cross-Review Lanes

- Developer code -> Technical Architect review.
- Technical Architect code -> Developer review.
- Frontend code by Developer/Technical Architect -> Frontend Designer review.
- Frontend Designer code -> Technical Architect review.
- QA owns final merge-readiness after required peer lanes.
- Security Reviewer is required for security-sensitive surfaces.

## Code Intelligence

- Prefer GitNexus MCP when present.
- Else use CodeGraph MCP when present.
- Else use built-in Read/Grep/Glob plus shell `rg` where allowed.
- For TypeScript/JavaScript in Claude Code, use exposed LSP tools or diagnostics from `typescript-lsp@claude-plugins-official` before grep fallback.
- Record availability in PM evidence and specialist packets. Do not call absent tools or block solely because code intelligence is unavailable.
