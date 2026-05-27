---
name: repo-init-official
description: "Use inside repo-init-scan to try `/init` or `copilot init`, normalize official init output into `.github/instructions/project.instructions.md`, and decide whether manual fallback is still needed."
---

# Repo Init Official

## Contract

- Try the active runtime's official initializer first when it is available.
- Prefer `/init` in Copilot CLI, VS Code Copilot, or Claude Code.
- Use `copilot init` only when shell execution is available and the command exists.
- Normalize useful output into the target `.github/instructions/project.instructions.md`.
- Do not treat command output alone as success. The facts file must exist on disk, not be a neutral scaffold, have no unresolved placeholders, and contain real facts or explicit `unknown` gaps for commands, runtime/framework, entrypoints, and module boundaries.
- If official init is unavailable, does not write the file, or leaves those fact categories incomplete, hand off to `repo-init-manual-fallback`.
- This stage does not certify scaffold completeness and does not write `best-copilot.md`; those remain owned by `repo-init-manual-fallback`.

## Output

```markdown
## Repo Init Official
- status: success|official_init_unavailable|official_init_no_write|official_init_incomplete
```
