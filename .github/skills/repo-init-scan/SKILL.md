---
name: repo-init-scan
description: "Use before the first substantial task in a newly adopted repository, or when `.github/copilot-instructions.md` still contains placeholders. Run or request Copilot's official `/init` / `copilot init`, then summarize repository facts into the project instructions, memory index, and current workstream. DO NOT USE FOR: routine tasks after repository facts are already current."
---

# Repo Init Scan

Use this skill to make the agent team learn the target repository before doing real work.

## Trigger

- First use of `best-copilot` in a repository.
- `.github/copilot-instructions.md` still has `<fill: ...>` placeholders.
- The user says the agent should scan, learn, onboard, initialize, or understand the repository.
- The current task depends on build, test, runtime, framework, or module facts that are not documented yet.

## Steps

1. Prefer the official Copilot initializer:
   - In Copilot CLI interactive mode, ask the user to run `/init`.
   - From a shell, ask the user to run `copilot init`.
2. If `/init` is unavailable in the current runtime, do a bounded manual scan:
   - Read `README*`, package/build files, CI files, app entrypoints, test directories, and existing `.github/copilot-instructions.md`.
   - Search only for build/test/dev entrypoints and major module boundaries.
   - If the repository has nested major modules, record candidates for hierarchical `AGENTS.md` or scoped instruction files, but do not create them unless requested.
3. Update repository facts only with evidence from current files or commands:
   - `.github/copilot-instructions.md`: build/test/dev commands, framework, entrypoints, security/API/UI/schema owners.
   - `memories/repo/project-state.md`: compact current state and constraints.
   - `memories/repo/current-workstreams.md`: current focus and next resume action.
   - `memories/repo/INDEX.md`: routing rows for changed memory files.
4. Keep instructions short. Do not paste long command output, logs, dependency trees, private hosts, tokens, or PII.
5. Verify:
   - No `<fill:` placeholders remain for facts that were discoverable.
   - Any unknown facts are explicitly marked `unknown`, not guessed.
   - At least one real build/test/check command is documented, or the reason is recorded.

## Output

Return a short initialization report:

```markdown
## Init Summary
- repo_type:
- key_entrypoints:
- build_test_commands:
- updated_files:
- unknowns:
- next_task_ready: yes|no
```
