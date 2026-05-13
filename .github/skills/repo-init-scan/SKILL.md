---
name: repo-init-scan
description: "Use before the first substantial task in a newly adopted repository, or when `.github/copilot-instructions.md` still contains placeholders. Run Copilot's official `/init` / `copilot init` when the runtime can do so, otherwise request it, then summarize repository facts into the project instructions, memory index, and current workstream. DO NOT USE FOR: routine tasks after repository facts are already current."
---

# Repo Init Scan

Use this skill to make the agent team learn the target repository before doing real work.

## Trigger

- First use of `best-copilot` in a repository.
- `.github/copilot-instructions.md` still has `<fill: ...>` placeholders.
- The user says the agent should scan, learn, onboard, initialize, or understand the repository.
- The current task depends on build, test, runtime, framework, or module facts that are not documented yet.

## Boundary

This skill is a first-substantial-task gate, not a plugin install hook. It cannot guarantee execution before any agent is invoked, and it cannot force `/init` in runtimes that do not expose slash commands or shell execution. The required behavior is:

- Before real requirements analysis, check whether repository facts are already initialized.
- If shell execution is available, run `copilot init` directly and then continue the user's task in the same conversation.
- If only Copilot interactive slash commands are available, ask the user to run `/init`, consume the resulting `.github/copilot-instructions.md`, and then continue the user's task in the same conversation.
- If official init is unavailable or incomplete, do the bounded manual scan below and record unknowns explicitly.

## Init State Detection

Judge initialization from target repository files, not from chat history or a hidden plugin flag.

Treat the repository as initialized when all of these are true:

- `.github/copilot-instructions.md` exists in the target repository.
- It has no unresolved init placeholders such as `<fill:`, `TODO init`, `TBD init`, or `project-specific-name`.
- It records at least one concrete build, test, check, lint, or dev command, or explicitly says those commands are `unknown` or not applicable.
- It records concrete project facts for runtime/framework, entrypoints, and module boundaries, or explicitly marks unknown gaps as `unknown`.

Do not rerun `/init` or `copilot init` merely because a new conversation started. Rerun official init only when the file is missing, still placeholder-heavy, or lacks the core fact categories above.

## Target Repository State

When this skill runs from an installed plugin, write persistent state into the target repository, never into the plugin installation/cache directory.

- Target project facts: `.github/copilot-instructions.md`.
- Target task memory: `memories/repo/INDEX.md`, `memories/repo/current-workstreams.md`, and compact topic files.
- Target specs: `spec/INDEX.md` and task-specific spec directories.
- Bundled `memories/` and `spec/` files in this plugin are templates and examples for the plugin repository itself. They are not shared storage for every installed project.
- If target `memories/repo` or `spec` files are absent and persistent recovery is needed, create the minimal skeleton in the target repository.

## Steps

1. Prefer the official Copilot initializer before substantive analysis:
   - From a shell-capable runtime, run `copilot init` directly.
   - In Copilot CLI interactive mode, ask the user to run `/init`.
   - Do not stop after initialization; normalize the facts and resume the original user request in the same conversation.
2. If `/init` is unavailable in the current runtime, or its output still leaves key facts unresolved, do a bounded manual scan:
   - Read `README*`, package/build files, CI files, app entrypoints, test directories, and existing `.github/copilot-instructions.md`.
   - Search only for build/test/dev entrypoints and major module boundaries.
   - If the repository has nested major modules, record candidates for hierarchical `AGENTS.md` or scoped instruction files, but do not create them unless requested.
3. Normalize repository facts only with evidence from current files or commands:
   - `.github/copilot-instructions.md`: build/test/dev commands, framework, entrypoints, security/API/UI/schema owners.
   - `memories/repo/project-state.md`: compact current state and constraints.
   - `memories/repo/current-workstreams.md`: current focus and next resume action.
   - `memories/repo/INDEX.md`: routing rows for changed memory files.
   - `spec/INDEX.md`: active spec routing when a spec is created or updated.
4. Keep instructions short. Do not paste long command output, logs, dependency trees, private hosts, tokens, or PII.
5. Normalize for reuse:
   - Keep the facts generic enough to survive future tasks in the same repository.
   - Mark unresolved facts explicitly as `unknown` instead of guessing.
   - Record only the smallest set of repo facts needed for later routing and verification.
6. Verify:
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
