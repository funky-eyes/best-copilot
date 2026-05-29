---
name: repo-init-scan
description: "Use after repo-init-gate fails, or when explicit reinitialization/repair is requested, to orchestrate the official init stage and the manual fallback stage."
---

# Repo Init Scan

Use this thin orchestrator when the repository needs full init or scaffold repair.

## Entry Contract

- Default path: invoke `repo-init-gate` first, then load this skill only when the gate reports `needs_init`, `version_mismatch`, or `invalid_sentinel`.
- If this skill is called directly without gate context, it may do one shallow read of the target root `best-copilot.md` and return early when the sentinel already matches.
- Explicit reinitialize/repair requests may bypass the gate.
- Stage order: `repo-init-official` first, then `repo-init-manual-fallback`.

## Boundary

- This skill is fail-closed. Do not continue to substantive planning or implementation until required scaffolds are verified and `best-copilot.md` has been rewritten for version `0.5.1`.
- Loading this skill is not execution. In Claude Code, `Skill(best-copilot:repo-init-scan) Successfully loaded` is only a preload trace. A valid `INIT_SCAN` requires running the stages below, creating or repairing target-local files when needed, checking them on disk, and returning the init summary.
- Do not dispatch specialist agents, run broad code search, or produce architecture/implementation plans while `required_artifacts_verified` is not `yes`.
- The next observable assistant action after loading this skill must be either the staged init work or a `BLOCKED` init report. A codegraph call, business-source read/search, architecture summary, or specialist dispatch before the init summary is invalid.

## Stage Split

- `repo-init-official` owns `/init` or `copilot init`, plus normalization of official output into `.github/instructions/project.instructions.md` when possible. In Claude Code, a helper-created `CLAUDE.md` is also a valid official artifact for `repo-init-manual-fallback` to preserve and normalize.
- `repo-init-manual-fallback` owns bounded manual scanning, scaffold bootstrap, artifact verification, and writing `best-copilot.md`.
- Official init success is not enough on its own. After `repo-init-gate` fails, the manual fallback stage still owns the final scaffold verification barrier and sentinel rewrite.
- In Claude Code, distinguish the bare built-in `/init` command from best-copilot plugin skills. The official stage must try Claude's native initializer automatically through `repo-init-official/scripts/run-claude-native-init.sh` before falling back to bounded manual scanning.

## Steps

1. If this skill was invoked directly without `repo-init-gate`, do one shallow read of the target root `best-copilot.md` first:
   - Matching sentinel: stop and treat repo init as already verified.
   - Missing, unreadable, invalid, or mismatched sentinel: continue to the staged init flow.
2. Run `repo-init-official` first.
3. Run `repo-init-manual-fallback` after the official stage:
   - On official success, use it to verify scaffolds, repair any remaining gaps, and rewrite `best-copilot.md`.
   - On official unavailability, no-write, or incomplete output, use it to do the bounded manual repair and then rewrite `best-copilot.md`.
4. In Claude Code, invoke the best-copilot stage skills when available, using the exact picker value such as `/repo-init-official (best-copilot)` or `/best-copilot:repo-init-official`, then `/repo-init-manual-fallback (best-copilot)` or `/best-copilot:repo-init-manual-fallback`. These plugin skills are different from the bare built-in `/init` command. If `Skill(...) Successfully loaded` appears but no actual init operations happen, that means the skill text loaded but was not executed — execute the documented steps inline now. If the runtime only loads the skill text or cannot invoke plugin slash commands, execute the documented fallback inline: apply the official stage rules, then read the bootstrap skill templates and create/repair the target files directly.
5. Stop only when the target repository has a verified `.github/instructions/project.instructions.md`, all required scaffolds, and a rewritten `best-copilot.md` sentinel for version `0.5.1`.
6. If either stage cannot complete its verification barrier, return `BLOCKED` instead of continuing to the user's substantive task.

## Output

Return a short initialization report:

```markdown
## Init Summary
- official_stage: success|official_init_unavailable|official_init_no_write|official_init_incomplete
- official_attempted: copilot_init|claude_native_init|bare_init|none
- manual_fallback_stage: skipped|success|blocked
- required_artifacts_verified: yes|no
- sentinel_written: yes|no
- next_task_ready: yes|no
- verified_paths: <compact list of required artifacts checked, or missing paths>
```

`sentinel_written: yes` means the current `best-copilot.md` sentinel is present and current, whether it was newly written or already present. `next_task_ready` may be `yes` only when `required_artifacts_verified` is `yes` and `sentinel_written` is `yes`. If either is `no`, the PM must stop at the first-use gate and return `BLOCKED`, not a normal plan or implementation summary.

`manual_fallback_stage: skipped` is allowed only when this skill was called directly and the current sentinel already matched before any gate failure. After `repo-init-gate` reports a missing, invalid, or stale sentinel, the manual fallback stage must run because it owns scaffold verification and sentinel rewrite.
