---
name: senior-project-expert
description: "Compatibility entrypoint for runtimes that resolve the Senior Project Expert name as a skill instead of the Senior Project Expert agent. Runs the same init preflight before PM/coordinator workflow."
---

# Senior Project Expert Compatibility Skill

This skill is a compatibility alias, not a second role definition. Use it when a runtime actually loads the Senior Project Expert request as a skill, for example `Skill(best-copilot:senior-project-expert)` or a legacy log such as `Skill(senior-project-expert)`. In Claude Code, use `--agent senior-project-expert` or the Claude `agent` setting for reliable first-use gates; if Claude reports an agent-name collision, use scoped `best-copilot:senior-project-expert`. `/agents` and `@` typeahead display plugin subagents under scoped names such as `best-copilot:senior-project-expert`, and that scoped mention is valid when the UI accepts it as an agent token. Do not depend on a plain-text prompt mention as the only first-use gate.

## Mandatory Boot Sequence

> **Claude Code Anti-Skip:** `Skill(...) Successfully loaded` is instruction-loading evidence ONLY. It does NOT mean the workflow ran. You MUST execute the steps inside the loaded skill and produce the structured output block before proceeding. If you see only a `Skill(...)` load line without the gate/scan output block, the preflight is INCOMPLETE.
> For `repo-init-gate`, the next observable action after the skill load MUST be reading only target-root `best-copilot.md` and emitting `## Repo Init Gate`. `Skill(best-copilot:repo-init-gate) Successfully loaded` followed by `Searched`, source `Read`, codegraph, project-structure exploration, planning, or dispatch before that block is invalid; recover by ignoring the premature context and executing the gate inline immediately.
> For `repo-init-scan`, the next observable action after the skill load MUST be staged init work or `BLOCKED`, ending in `## Init Summary`; source search/read before that summary is invalid.
> Do not synthesize init success. If no file read/write or disk verification actually ran, return `BLOCKED tool_execution_unavailable`; a prose-only `## Init Summary` without required yes/no fields, every path from `repo-init-scan` Required Artifact Set, and `missing_paths: none` is invalid.

1. Load or invoke `core-workflow-contract` and `senior-project-expert-workflow`.
2. For target-repository analysis, planning, review, or implementation requests, run `repo-init-gate` before classification, broad search, generic Explore workers, planning, dispatch, or implementation. Running the gate means reading only target-root `best-copilot.md` and emitting `## Repo Init Gate`, not merely loading the skill text.
3. If `repo-init-gate` reports a matching `best-copilot.md` sentinel, output `INIT_SCAN=SKIP_SENTINEL_READY` and continue with the Senior Project Expert workflow.
4. If `repo-init-gate` reports `needs_init`, `version_mismatch`, or `invalid_sentinel`, run `repo-init-scan` and stop unless its report has `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.
5. **HARNESS_DEGRADED fallback (exact steps):** If `repo-init-gate` returns `HARNESS_DEGRADED skill_invocation_unavailable`, perform the gate fallback inline:
   - Read the target root `best-copilot.md`.
   - If the full file exactly matches the three-line sentinel from `repo-init-gate` → record `INIT_SCAN=SKIP_SENTINEL_READY`, continue.
   - If missing/mismatch → invoke `/best-copilot:repo-init-scan` and execute its stages (`repo-init-official` → `repo-init-manual-fallback`). Do NOT skip to analysis.
6. The best-copilot `repo-init-official` skill is a stage wrapper, not the same as Claude Code's bare `/init` command. In Claude Code, `repo-init-official` must run its bundled helper from the target root; that helper invokes a target-local `init` skill first when `skills/init/SKILL.md` or `.claude/skills/init/SKILL.md` exists, then falls back to native `/init` through `claude --bare --permission-mode acceptEdits -p "/init"` before manual fallback.
7. In Claude Code, a transcript line such as `Skill(best-copilot:repo-init-scan) Successfully loaded` is not an init result. It only means the skill text is available. Continue only after the scan has verified or created the target-local files, written the sentinel when needed, and reported `required_artifacts_verified: yes`, `sentinel_written: yes`, and `next_task_ready: yes`.
8. Do not treat an unknown-agent, unknown-skill, or skill-load-only path as permission to continue without the init gate.

## Observable Output

For any non-micro target-repository request, show this stage trail before substantive work:

```text
INIT_GATE -> [INIT_SCAN if needed] -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION -> [ARCHITECT_SDD if full/ambiguous/high-risk] -> REVIEW_OR_DISPATCH -> FAN_IN_ARBITRATION -> NEXT_GATE
```

After the boot sequence succeeds, continue exactly as Senior Project Expert: freeze the shared six-block packet, use named specialist lanes where available, forbid specialists from asking the user directly, fan in structured handbacks, verify before completion, and use the native closeout/continuation gate when available.

## Eval Prompts

- Prompt: launch Claude Code with `claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert`, then ask `Analyze this OAuth2 server and plan OIDC support.`
  - Expected: uses the Senior Project Expert subagent path and starts with `INIT_GATE`, runs `repo-init-scan` when the sentinel is absent or stale, and does not analyze OAuth2/OIDC code until `next_task_ready: yes`.
- Prompt: launch Claude Code without `--agent`, type `@best-copilot`, and select `best-copilot:senior-project-expert (agent)` from the typeahead, producing a token like `@"best-copilot:senior-project-expert (agent)"`.
  - Expected: invokes the scoped plugin subagent path and starts with `INIT_GATE`. This is valid explicit subagent selection, but `--agent senior-project-expert` or the Claude `agent` setting remains the reliable default PM session entry.
- Prompt: `/senior-project-expert Review the architecture for a Spring Boot auth service upgrade.`
  - Expected: if the runtime accepts the bare legacy form, loads this compatibility entrypoint, invokes `core-workflow-contract` and `senior-project-expert-workflow`, performs the init preflight, then classifies the request as full/design-review and routes named lanes where available. The canonical Claude plugin-skill form is `/best-copilot:senior-project-expert`.
- Prompt: `Use senior-project-expert as lead for an agent team.`
  - Expected: prefers the subagent path when available; if only the skill path loads, reports the compatibility path and still enforces the init preflight before PM fan-out.
- Prompt: launch Claude Code without `--agent`, then type `Use senior-project-expert for this target-repository review.`
  - Expected: if the runtime resolves the request as this skill, reports the compatibility path and still enforces the init preflight. If it stays plain text and no agent/skill is active, it must not be presented as the reliable first-use gate; restart with `--agent senior-project-expert` or set the Claude `agent` setting.
