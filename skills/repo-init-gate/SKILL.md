---
name: repo-init-gate
description: "Use before repo-init-scan to cheaply decide whether a target repository already satisfies the current best-copilot init contract by reading only the root `best-copilot.md` sentinel."
---

# Repo Init Gate

Use this tiny skill before loading `repo-init-scan`.

## Immediate Execution Rule

When this skill has just been loaded, the very next assistant action must be the gate itself:

1. Read only the target root `best-copilot.md`, or determine that it is missing or unreadable.
2. Compare the full file content with the expected sentinel block below.
3. Emit the `## Repo Init Gate` output block below.
4. Only after that block exists, decide whether to skip or run `repo-init-scan`.

Do not search, grep, glob, list business source, inspect modules such as `core`, call code intelligence, plan, dispatch, or summarize implementation before this block is emitted. A transcript that shows `Skill(...repo-init-gate...) Successfully loaded` followed by `Searched`, source `Read`, code intelligence, project-structure exploration, or planning before `## Repo Init Gate` is invalid. Recovery is to discard that premature source context and run this rule inline immediately.

## Contract

- This is the mandatory first observable preflight for Senior Project Expert target-repository requests. Run it before classification, broad search, generic Explore workers, planning, dispatch, or implementation.
- Loading this skill is not the gate result. The gate result exists only after the target root `best-copilot.md` has been read or found missing and the output block below is produced.
- In Claude Code, if invoking this skill only prints `Skill(...) Successfully loaded`, execute the gate inline immediately: read only target-root `best-copilot.md`, compare the frontmatter to the expected content below, and emit the output block.
- Read only the target root `best-copilot.md`.
- Expected file content is exactly:

```md
---
version: "0.6.0"
---
```

- Exact match: skip `repo-init-scan`.
- Missing, unreadable, invalid frontmatter, missing `version`, or version mismatch: run `repo-init-scan`.
- Do not create, write, or edit `best-copilot.md`. This gate is read-only. If the sentinel is missing or mismatched, report the gate result and hand off to `repo-init-scan` which owns creating it.
- Do not create, write, or edit any scaffold files during this gate. Gate is a single-file read operation.
- Any extra heading, prose, task summary, or project description in `best-copilot.md` makes it `invalid_sentinel`, even when a version string appears somewhere in the file.
- Do not read `.github/instructions/**`, `memories/repo/**`, `spec/**`, or runtime adapters here.
- Explicit reinitialize/repair requests bypass the gate and run `repo-init-scan` directly.
- `best-copilot.md` is written only by `repo-init-scan` after full verification.
- If a runtime cannot mechanically invoke this skill, use the same shallow sentinel read as a degraded fallback and report `HARNESS_DEGRADED skill_invocation_unavailable`.

## Output

```markdown
## Repo Init Gate
- gate_result: ready|needs_init|version_mismatch|invalid_sentinel
- next_action: skip_repo_init_scan|run_repo_init_scan
- evidence: target_root_best_copilot_md=present|missing|unreadable, observed_version=<version-or-none>
```
