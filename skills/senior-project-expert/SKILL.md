---
name: senior-project-expert
description: "Compatibility entrypoint for runtimes that resolve the Senior Project Expert name as a skill instead of the Senior Project Expert agent. Runs the same init preflight before PM/coordinator workflow."
---

# Senior Project Expert Compatibility Skill

This skill is a compatibility alias, not a second role definition. Use it when a runtime actually loads the Senior Project Expert request as a skill, for example `Skill(best-copilot:senior-project-expert)` or a legacy log such as `Skill(senior-project-expert)`. In Claude Code, use `--agent senior-project-expert` or the Claude `agent` setting for reliable first-use gates; if Claude reports an agent-name collision, use scoped `best-copilot:senior-project-expert`. `/agents` and `@` typeahead display plugin subagents under scoped names such as `best-copilot:senior-project-expert`, and that scoped mention is valid when the UI accepts it as an agent token. Do not depend on a plain-text prompt mention as the only first-use gate.

## Mandatory Boot Sequence

1. Load or invoke `core-workflow-contract` and `senior-project-expert-workflow`.
2. For target-repository analysis, planning, review, or implementation requests, run `repo-init-gate` before classification, broad search, generic Explore workers, planning, dispatch, or implementation.
3. If `repo-init-gate` reports a matching `best-copilot.md` sentinel, output `INIT_SCAN=SKIP_SENTINEL_READY` and continue with the Senior Project Expert workflow.
4. If `repo-init-gate` reports `needs_init`, `version_mismatch`, or `invalid_sentinel`, run `repo-init-scan` and stop unless its report has `next_task_ready: yes`.
5. If this runtime cannot invoke the gate skill mechanically, perform the gate's documented fallback exactly: read only the target root `best-copilot.md`, compare it to the current sentinel version, and report `HARNESS_DEGRADED skill_invocation_unavailable` before deciding whether `repo-init-scan` is required.
6. Do not treat an unknown-agent or unknown-skill failure as permission to continue without the init gate.

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
