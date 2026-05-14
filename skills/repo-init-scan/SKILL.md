---
name: repo-init-scan
description: "Use before the first substantial task in a newly adopted repository, when `.github/instructions/project.instructions.md` is missing/placeholder-heavy, or when target-local instruction/memory/spec scaffolds are missing on first plugin use. Run official init when facts are incomplete, then execute target bootstrap skills. DO NOT rerun official init merely because scaffolds are missing."
---

# Repo Init Scan

Use this skill to make the agent team learn the target repository before doing real work.

## Trigger

- First use of `best-copilot` in a repository.
- `.github/instructions/project.instructions.md` still has `<fill: ...>` placeholders.
- Target-local `.github/instructions/**`, `memories/repo/**`, or `spec/**` scaffolds are missing during first substantial plugin use.
- The user says the agent should scan, learn, onboard, initialize, or understand the repository.
- The current task depends on build, test, runtime, framework, or module facts that are not documented yet.

## Boundary

This skill is a first-substantial-task gate, not a plugin install hook. It cannot guarantee execution before any agent is invoked, and it cannot force `/init` in runtimes that do not expose slash commands or shell execution. The required behavior is:

This skill is fail-closed once selected. If repository facts or required first-use scaffolds are missing, do not continue to requirements analysis, planning, framework migration, dependency changes, security rewrites, or implementation until the required files have been created or a `BLOCKED` result has been returned. Reading package/build files is allowed only as bounded evidence for creating `.github/instructions/project.instructions.md`; it is not permission to start the substantive task.

- Before real requirements analysis, check whether repository facts are already initialized and whether target-local scaffolds exist.
- If repository facts are incomplete and shell execution is available, run `copilot init` directly, normalize useful output or artifacts into `.github/instructions/project.instructions.md`, and then continue the user's task in the same conversation only after required artifacts are verified.
- If repository facts are incomplete and only Copilot interactive slash commands are available, ask the user to run `/init`, consume the resulting output or artifacts, normalize them into `.github/instructions/project.instructions.md`, and then continue the user's task in the same conversation only after required artifacts are verified.
- If official init is unavailable or incomplete, do the bounded manual scan below and record unknowns explicitly.
- After repository facts exist, initialize missing target-local instruction, memory, and spec scaffolds through the bootstrap skills in this plugin.
- A `skill(repo-init-scan)` marker alone is not success. Success requires on-disk verification of the target files listed in `Required First-Use Artifacts`.

## Required First-Use Artifacts

Before `next_task_ready: yes`, verify these paths in the target repository:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
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

If the project facts file is missing and the current runtime has file-write capability, create or repair it from official init output and bounded repository evidence. Create the remaining missing scaffolds by executing the matching bootstrap skill. If file-write capability is unavailable or the target repository path is ambiguous, return `BLOCKED` with `first_use_artifacts_missing` and list the missing paths. Do not continue the original task in the same turn until this barrier passes.

## Init State Detection

Judge initialization from target repository files, not from chat history or a hidden plugin flag.

Treat the repository as initialized when all of these are true:

- `.github/instructions/project.instructions.md` exists in the target repository.
- It has no unresolved init placeholders such as `<fill:`, `TODO init`, `TBD init`, or `project-specific-name`.
- It is not the untouched neutral scaffold from `target-instructions-bootstrap`; markers such as `Init source: manual scaffold` or `Last verified: unknown` must be replaced before the file counts as initialized.
- It records at least one concrete build, test, check, lint, or dev command, or explicitly says those commands are `unknown` or not applicable after a bounded scan.
- It records concrete project facts for runtime/framework, entrypoints, and module boundaries, or explicitly marks unknown gaps as `unknown` after a bounded scan.

Do not rerun `/init` or `copilot init` merely because a new conversation started or because scaffolds are missing. Rerun official init only when the file is missing, still placeholder-heavy, or lacks the core fact categories above. If facts are current but scaffolds are missing, skip official init and run only the bootstrap skills.

The `copilot init` command returning output is not enough. Immediately after running it, write or repair `.github/instructions/project.instructions.md` from official output and bounded repository evidence, then re-check it on disk. If the file is still missing or incomplete, record `official_init_no_write` or `official_init_incomplete` and continue only with bounded manual scan plus local file creation.

## Target Repository State

When this skill runs from an installed plugin, write persistent state into the target repository, never into the plugin installation/cache directory.

Do not copy this plugin repository's instruction files, memory files, specs, or active workflow state into the target repository. Target repositories get their own neutral local files from `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then later tasks fill those files with target-specific facts.

- Target project facts: `.github/instructions/project.instructions.md`.
- Target instructions: `.github/instructions/**` and optional `AGENTS.md`.
- Target task memory: `memories/repo/INDEX.md`, `memories/repo/current-workstreams.md`, and compact topic files.
- Target specs: `spec/INDEX.md` and task-specific spec directories.
- This plugin checkout does not keep active target-project `memories/` or `spec/` directories. Installed projects get durable scaffolds from `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- If target `memories/repo` or `spec` files are absent and persistent recovery may be needed for the current or future MEDIUM/LARGE task, create the minimal skeleton in the target repository.

## Steps

1. Prefer the official Copilot initializer before substantive analysis only when repository facts are incomplete:
   - From a shell-capable runtime, run `copilot init` directly.
   - In Copilot CLI interactive mode, ask the user to run `/init`.
   - Do not stop after initialization; normalize the facts and resume the original user request in the same conversation.
2. Normalize and verify official init by reading the target repository file:
   - Write useful `/init` or `copilot init` output into `.github/instructions/project.instructions.md` when the file is missing or incomplete.
   - Check that `.github/instructions/project.instructions.md` exists after normalization.
   - Check that the file has no unresolved init placeholders, is not the untouched neutral scaffold, and contains the required command/runtime/entrypoint/module facts or bounded-scan `unknown` gaps.
   - If the file is missing, do not attempt to read it again as if init succeeded. Create `.github/` and proceed to the bounded manual fallback.
3. If `/init` is unavailable, does not write the file, or still leaves key facts unresolved, do a bounded manual scan:
   - Read `README*`, package/build files, CI files, app entrypoints, test directories, and existing `.github/instructions/project.instructions.md`.
   - Search only for build/test/dev entrypoints and major module boundaries.
   - If the repository has nested major modules, record candidates for hierarchical `AGENTS.md` or scoped instruction files, but do not create them unless requested.
4. Create or update the target repository initialization artifacts:
   - `.github/instructions/project.instructions.md`: build/test/dev commands, framework, entrypoints, security/API/UI/schema owners.
   - Minimum `.github/instructions/project.instructions.md` sections: `Project Facts`, `Build and Test Commands`, `Runtime and Entry Points`, `Module Boundaries`, `Known Unknowns`, and `Verification Notes`.
   - Replace neutral scaffold markers with `Init source: official_init|manual_fallback|official_init_plus_manual_fallback` and a real verification timestamp or bounded-scan note.
5. Initialize missing target-local scaffolds by loading and executing these skills in order:
   - `target-instructions-bootstrap`: create missing `.github/instructions/**` and optional `AGENTS.md`.
   - `target-memory-bootstrap`: create missing `memories/repo/**` skeleton during first substantial plugin use, and later whenever persistent recovery is needed.
   - `target-spec-bootstrap`: create missing `spec/INDEX.md` and `spec/templates/**` during first substantial plugin use, and later before writing any spec.
6. Re-check the `Required First-Use Artifacts` paths on disk. If any required file is still absent, stop with `BLOCKED`; do not downgrade this to `unknown` and do not proceed to dependency, framework, security, or application analysis.
7. Keep instructions short. Do not paste long command output, logs, dependency trees, private hosts, tokens, or PII.
8. Normalize for reuse:
   - Keep the facts generic enough to survive future tasks in the same repository.
   - Mark unresolved facts explicitly as `unknown` instead of guessing.
   - Record only the smallest set of repo facts needed for later routing and verification.
9. Verify:
   - `.github/instructions/project.instructions.md` exists on disk in the target repository.
   - Any bootstrap-created files exist on disk in the target repository and did not overwrite existing project-specific content.
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
- bootstrapped:
  - instructions: yes|no|skipped_existing
  - memory: yes|no|skipped_existing
  - spec: yes|no|skipped_existing
- required_artifacts_verified: yes|no
- missing_required_artifacts:
- init_source: official_init|manual_fallback|official_init_plus_manual_fallback
- fallback_reason:
- unknowns:
- next_task_ready: yes|no
```

`next_task_ready` may be `yes` only when `required_artifacts_verified` is `yes`. If it is `no`, the PM must stop at the first-use gate and return `BLOCKED`, not a normal plan or implementation summary.
