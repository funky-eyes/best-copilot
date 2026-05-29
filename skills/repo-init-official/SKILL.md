---
name: repo-init-official
description: "Use inside repo-init-scan to try `/init` or `copilot init`, normalize official init output into `.github/instructions/project.instructions.md`, and decide whether manual fallback is still needed."
---

# Repo Init Official

## Contract

- This is the best-copilot official-init stage. Loading `/best-copilot:repo-init-official` or `Skill(best-copilot:repo-init-official)` makes this stage's instructions available; it is not the same thing as running the runtime's built-in `/init`.
- Try the active runtime's official initializer first when it is available.
- In Copilot CLI or other shell-capable runtimes, if `copilot init` exists, run it automatically before manual fallback. This is the normal automatic official-init path for Copilot.
- In Claude Code, attempt the built-in `/init` automatically through the bundled helper script before manual fallback: run `bash ${CLAUDE_SKILL_DIR}/scripts/run-claude-native-init.sh <target-root>`. The helper uses `claude --bare --permission-mode acceptEdits -p "/init"` so the native Claude initializer writes the target `CLAUDE.md` without loading this plugin recursively.
- Prefer a directly invokable bare runtime `/init` command when the active session exposes one. This bare `/init` is distinct from best-copilot plugin skills such as `/repo-init-official` or `/best-copilot:repo-init-official`.
- Normalize useful output into the target `.github/instructions/project.instructions.md` when the official initializer produces enough facts directly. For Claude native `/init`, a target `CLAUDE.md` written by the helper is also a successful official artifact; `repo-init-manual-fallback` must then preserve it and normalize its useful facts into `.github/instructions/project.instructions.md`.
- Do not treat chat output alone as success. Either the facts file must exist on disk with real facts or explicit `unknown` gaps, or Claude native `/init` must have written a target `CLAUDE.md` artifact that the manual fallback can normalize.
- In Claude Code, do not report `official_init_unavailable` merely because the assistant cannot call a UI slash command directly. First try the helper script. If the helper succeeds and `CLAUDE.md` exists, report `success`.
- Report `official_init_unavailable` only when no official initializer is available or known in the current runtime, no `copilot init` command can be run, and no prior `/init` / `copilot init` output or artifacts are available to normalize.
- If official init runs but only returns chat text without a verified facts file, report `official_init_no_write` and continue to `repo-init-manual-fallback`. Do not stop after loading this skill.
- If official init is unavailable, does not write the file, or leaves those fact categories incomplete, hand off to `repo-init-manual-fallback`.
- This stage does not certify scaffold completeness and does not write `best-copilot.md`; those remain owned by `repo-init-manual-fallback`.

## Output

```markdown
## Repo Init Official
- status: success|official_init_unavailable|official_init_no_write|official_init_incomplete
- attempted: copilot_init|claude_native_init|bare_init|none
- artifacts: <files created or normalized, such as CLAUDE.md and .github/instructions/project.instructions.md>
```
