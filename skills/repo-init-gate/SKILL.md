---
name: repo-init-gate
description: "Use before repo-init-scan to cheaply decide whether a target repository already satisfies the current best-copilot init contract by reading only the root `best-copilot.md` sentinel."
---

# Repo Init Gate

Use this tiny skill before loading `repo-init-scan`.

## Contract

- Read only the target root `best-copilot.md`.
- Expected file content is exactly:

```md
---
version: "0.5.0"
---
```

- Exact match: skip `repo-init-scan`.
- Missing, unreadable, invalid frontmatter, missing `version`, or version mismatch: run `repo-init-scan`.
- Do not read `.github/instructions/**`, `memories/repo/**`, `spec/**`, or runtime adapters here.
- Explicit reinitialize/repair requests bypass the gate and run `repo-init-scan` directly.
- `best-copilot.md` is written only by `repo-init-scan` after full verification.

## Output

```markdown
## Repo Init Gate
- gate_result: ready|needs_init|version_mismatch|invalid_sentinel
- next_action: skip_repo_init_scan|run_repo_init_scan
```