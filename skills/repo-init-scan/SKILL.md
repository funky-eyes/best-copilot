---
name: repo-init-scan
description: "Use after repo-init-gate fails, or when explicit reinitialization/repair is requested, to orchestrate the official init stage and the manual fallback stage."
---

# Repo Init Scan

Use this thin orchestrator when the repository needs full init or scaffold repair.

## Immediate Execution Rule

When this skill has just been loaded after `repo-init-gate` failed, the very next assistant action must be staged init work or a `BLOCKED` init report:

1. In shell-capable runtimes, run the single-command bootstrap path first when the helper path is discoverable. For Claude Code, resolve it with `CLAUDE_SKILL_DIR` when present, otherwise use the active plugin directory when available and run `<plugin-dir>/skills/repo-init-scan/scripts/bootstrap-after-gate-failure.sh <target-root> claude`. This command owns the official attempt, deterministic manual fallback helper, disk verification, sentinel rewrite, and `## Init Summary` output. If the helper path is not discoverable, continue to the strict inline fallback below instead of blocking solely on helper discovery.
2. If that script is unavailable, run `repo-init-official` first, or execute its documented official-init fallback inline when slash skill execution is unavailable.
3. Then run `repo-init-manual-fallback`, including its bundled deterministic scaffold helper when shell access is available, or execute its documented scaffold verification and repair inline.
4. Verify every required artifact from `repo-init-manual-fallback` on disk, rewrite the exact `best-copilot.md` sentinel when needed, and emit `## Init Summary`.

Do not hand-create a shortened scaffold, search/read business source, inspect modules such as `core`, call codegraph, plan, dispatch, or summarize implementation after a `Skill(...repo-init-scan...) Successfully loaded` line and before `## Init Summary`. That transcript is invalid; recover by ignoring the premature context and executing the single-command bootstrap path, strict 17-path inline fallback, or staged init flow now. If file read/write or disk verification cannot actually run, return `BLOCKED tool_execution_unavailable`; never produce a prose-only success summary.

## Entry Contract

- Default path: invoke `repo-init-gate` first, then load this skill only when the gate reports `needs_init`, `version_mismatch`, or `invalid_sentinel`.
- If this skill is called directly without gate context, it may do one shallow read of the target root `best-copilot.md` and return early when the sentinel already matches.
- Explicit reinitialize/repair requests may bypass the gate.
- Stage order: `repo-init-official` first, then `repo-init-manual-fallback`.

## Boundary

- This skill is fail-closed. Do not continue to substantive planning or implementation until required scaffolds are verified and `best-copilot.md` has been rewritten for version `0.6.0`.
- Loading this skill is not execution. In Claude Code, `Skill(best-copilot:repo-init-scan) Successfully loaded` is only a preload trace. A valid `INIT_SCAN` requires running the stages below, creating or repairing target-local files when needed, checking them on disk, and returning the init summary.
- In shell-capable Claude Code, a missing-sentinel scan should show the bundled `repo-init-scan/scripts/bootstrap-after-gate-failure.sh` command. If shell execution is blocked but file tools work, a strict inline fallback is valid only when all 17 Claude-compatible paths are created/repaired and verified. A hand-written two-file or four-file scaffold is invalid.
- Do not dispatch specialist agents, run broad code search, or produce architecture/implementation plans while `required_artifacts_verified` is not `yes`.
- The next observable assistant action after loading this skill must be either the staged init work or a `BLOCKED` init report. A codegraph call, business-source read/search, architecture summary, or specialist dispatch before the init summary is invalid.
- A valid missing-sentinel scan transcript contains `## Repo Init Gate` first, then real stage work, then the structured `## Init Summary` fields below. A narrative claim that files were created without verified paths is invalid.
- `required_artifacts_verified: yes` is forbidden unless `verified_paths` covers every required artifact from `repo-init-manual-fallback` and `missing_paths` is `none`. A partial verified list means `required_artifacts_verified: no`, `next_task_ready: no`, and `BLOCKED first_use_gate_incomplete`.

## Required Artifact Set

For `required_artifacts_verified: yes`, `verified_paths` must include these exact target-root paths. Similar paths do not count.

Claude-compatible first-use init has 17 required paths. Fewer verified paths means `required_artifacts_verified: no`, even if `best-copilot.md` and `.github/instructions/project.instructions.md` exist.

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `CLAUDE.md` when the active target runtime is Claude Code or Claude compatibility is requested
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
- `best-copilot.md` after the sentinel rewrite

Do not accept substitutes such as `memory/current-state.md`, `MEMORY.md`, `spec/requirements.md`, or `spec/templates/spec-template.md`. If any exact required path is absent or content-invalid, set `missing_paths` to those paths, `required_artifacts_verified: no`, `next_task_ready: no`, and return `BLOCKED first_use_gate_incomplete`.

The `verified_paths` output field must enumerate the exact relative path names. A phrase such as `all 17 required paths`, `created successfully`, or an absolute temp directory path is not valid evidence.

## Stage Split

- `repo-init-official` owns `/init` or `copilot init`, plus normalization of official output into `.github/instructions/project.instructions.md` when possible. In Claude Code, `/init` means Claude Code's native command shown as "Initialize a new CLAUDE.md file with codebase documentation", not a best-copilot skill. In Copilot CLI, `copilot init` is the native official initializer when the command exists. A helper-created `CLAUDE.md`, `.github/instructions/project.instructions.md`, or `AGENTS.md` is also a valid official artifact for `repo-init-manual-fallback` to preserve and normalize.
- `repo-init-manual-fallback` owns bounded manual scanning, deterministic scaffold bootstrap, artifact verification, and writing `best-copilot.md`.
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
4. In Claude Code, when shell access exists, prefer the current skill's resolved single-command path using `CLAUDE_SKILL_DIR` or the active plugin directory when available. Otherwise invoke the best-copilot stage skills when available, using the exact picker value such as `/repo-init-official (best-copilot)` or `/best-copilot:repo-init-official`, then `/repo-init-manual-fallback (best-copilot)` or `/best-copilot:repo-init-manual-fallback`. These plugin skills are different from the bare built-in `/init` command. If `Skill(...) Successfully loaded` appears but no actual init operations happen, that means the skill text loaded but was not executed — execute the documented steps inline now. If shell access exists and the manual fallback helper is discoverable, run its bundled `scripts/bootstrap-target-scaffold.sh` helper before any hand-written scaffold attempt. If the runtime only loads the skill text or cannot invoke plugin slash commands or discover the helper, execute the documented fallback inline: apply the official stage rules, then read the bootstrap skill templates and create/repair the target files directly.
5. Stop only when the target repository has a verified `.github/instructions/project.instructions.md`, all required scaffolds, and a rewritten `best-copilot.md` sentinel for version `0.6.0`.
6. If either stage cannot complete its verification barrier, return `BLOCKED` instead of continuing to the user's substantive task.

## Output

Return a short initialization report:

```markdown
## Init Summary
- official_stage: success|official_init_unavailable|official_init_no_write|official_init_incomplete
- official_attempted: copilot_init|claude_native_slash_init|bare_init|none
- manual_fallback_stage: skipped|success|blocked
- required_artifacts_verified: yes|no
- sentinel_written: yes|no
- next_task_ready: yes|no
- verified_paths: <every required artifact from repo-init-manual-fallback checked on disk, plus best-copilot.md>
- missing_paths: none|<paths not present or not content-valid>
```

`sentinel_written: yes` means the current `best-copilot.md` sentinel is present and current, whether it was newly written or already present. `required_artifacts_verified: yes` may be used only when `missing_paths` is `none` and `verified_paths` covers the full Required Artifact Set above, including Claude `CLAUDE.md` when Claude compatibility is active. `next_task_ready` may be `yes` only when `required_artifacts_verified` is `yes` and `sentinel_written` is `yes`. If any path is missing or unverified, the PM must stop at the first-use gate and return `BLOCKED first_use_gate_incomplete`, not a normal plan or implementation summary.

`manual_fallback_stage: skipped` is allowed only when this skill was called directly and the current sentinel already matched before any gate failure. After `repo-init-gate` reports a missing, invalid, or stale sentinel, the manual fallback stage must run because it owns scaffold verification and sentinel rewrite.
