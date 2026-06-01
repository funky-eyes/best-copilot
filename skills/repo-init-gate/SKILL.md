---
name: repo-init-gate
description: "Use before repo-init-scan to cheaply decide whether a target repository already satisfies the current best-copilot init contract by reading only the root `best-copilot.md` sentinel."
---

# Repo Init Gate

Use this tiny skill before loading `repo-init-scan`. It is the repeat-request fast path.

## Immediate Execution Rule

When loaded, the next assistant action must be only this gate:

1. Read only the target root `best-copilot.md`, or determine that it is missing or unreadable.
2. Compare the full file content to the exact sentinel below.
3. Emit the `## Repo Init Gate` output block below.
4. If it matches, skip `repo-init-scan`; otherwise run `repo-init-scan`.

Forbidden before this block: search, grep, glob, source reads, project structure exploration, code intelligence, planning, dispatch, implementation summaries, scaffold writes, or reading `.github/instructions/**`, `memories/**`, `spec/**`, `AGENTS.md`, or `CLAUDE.md`.

## Contract

Expected `best-copilot.md` content:

```md
---
version: "0.6.0"
---
```

- Exact full-file match: `ready` + `skip_repo_init_scan`.
- Missing, unreadable, extra content, invalid frontmatter, missing version, or version mismatch: report the corresponding gate result and run `repo-init-scan`.
- Explicit reinitialize/repair requests bypass this gate and run `repo-init-scan`.
- This gate is read-only; `repo-init-scan` owns sentinel creation/repair.
- If skill invocation fails, do the same single-file read inline and report `HARNESS_DEGRADED skill_invocation_unavailable`.

## Output

```markdown
## Repo Init Gate
- gate_result: ready|needs_init|version_mismatch|invalid_sentinel
- next_action: skip_repo_init_scan|run_repo_init_scan
- evidence: target_root_best_copilot_md=present|missing|unreadable, observed_version=<version-or-none>
```
