---
name: repo-init-scan
description: "Use before the first substantial task in a newly adopted repository, when `.github/instructions/project.instructions.md` is missing/placeholder-heavy, or when target-local instruction/memory/spec scaffolds are missing on first plugin use. Run official init when facts are incomplete, then execute target bootstrap skills. DO NOT rerun official init merely because scaffolds are missing."
---

# Repo Init Scan

Use this skill to make the agent team learn the target repository before doing real work.

## Trigger

- First use of `best-copilot` in a repository.
- `.github/instructions/project.instructions.md` still has `<fill: ...>` placeholders.
- Target-local `.github/instructions/**`, runtime adapter (`CLAUDE.md` for Claude Code when applicable), `memories/repo/**`, or `spec/**` scaffolds are missing during first substantial plugin use.
- The user says the agent should scan, learn, onboard, initialize, or understand the repository.
- The current task depends on build, test, runtime, framework, or module facts that are not documented yet.

## Boundary

This skill is a first-substantial-task gate, not a plugin install hook. It cannot guarantee execution before any agent is invoked, and it cannot force `/init` in runtimes that do not expose slash commands or shell execution. The required behavior is:

This skill is fail-closed once selected. If repository facts or required first-use scaffolds are missing, do not continue to requirements analysis, planning, framework migration, dependency changes, security rewrites, or implementation until the required files have been created or a `BLOCKED` result has been returned. Reading package/build files is allowed only as bounded evidence for creating `.github/instructions/project.instructions.md`; it is not permission to start the substantive task.

- Before real requirements analysis, check whether repository facts are already initialized and whether target-local scaffolds exist.
- If repository facts are incomplete and the active runtime exposes `/init`, run or ask the user to run `/init`, consume the resulting output or artifacts, normalize them into `.github/instructions/project.instructions.md`, and then continue the user's task in the same conversation only after required artifacts are verified.
- If repository facts are incomplete, shell execution is available, and `copilot init` exists, run `copilot init` directly, normalize useful output or artifacts into `.github/instructions/project.instructions.md`, and then continue the user's task in the same conversation only after required artifacts are verified.
- If official init is unavailable or incomplete, do the bounded manual scan below and record unknowns explicitly.
- After repository facts exist, initialize missing target-local instruction, memory, and spec scaffolds through the bootstrap skills in this plugin.
- A `skill(repo-init-scan)` marker alone is not success. Success requires on-disk verification of the target files listed in `Required First-Use Artifacts` plus the required content checks for instruction files.

## Required First-Use Artifacts

Before `next_task_ready: yes`, verify these paths in the target repository:

- `.github/instructions/project.instructions.md`
- `.github/instructions/must.instructions.md`
- `.github/instructions/skills-index.instructions.md`
- `CLAUDE.md` when the active target runtime is Claude Code or the user requests Claude Code compatibility.
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

Instruction files that exist but are older short scaffolds are not sufficient. Before `next_task_ready: yes`, verify:

- `.github/instructions/must.instructions.md` contains `## Request Flow` with the per-request timestamp rule, init normalization rule, and packet freeze rule.
- `.github/instructions/must.instructions.md` contains `## Per-Request Hard Gates`.
- That same file contains the native closeout requirement, the latest-runtime native ask availability rule, the VS Code `vscode_askQuestions` exact-tool priority, continuation/free-text invalidation, executable closeout-reply handling, and answer-only follow-up non-exemption.
- That same file says: when a closeout or continuation choice is needed, keep selectable options in the native structured prompt, not in a prose `1/2/3` list.
- That same file says specialists must not ask the user directly, must not call `Asking user`, `vscode_askQuestions`, `vscode/askQuestions`, or `askQuestions`, and must return `NEEDS_USER_INPUT` to PM/coordinator when one exists, or `BLOCKED missing_top_level_question` otherwise.
- That same file contains `## Shared State Contracts` with `work_mode`, `task_type`, and `pm_action`.
- That same file contains `## Search Precision` with fixed-string lookup before regex search.
- That same file contains `## Command Output Budget` with the default `COMMAND 2>&1 | head -c 4000` pattern.
- That same file contains the first-use scaffold gate naming `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- That same file contains the progressive-disclosure memory rule, mixed-language rule, `## Agents and Dispatch`, and `## Implementation and Verification`.
- `.github/instructions/skills-index.instructions.md` contains bootstrap skill routing and the `## Claude Code Skill Names` note.
- When Claude Code compatibility is required, `CLAUDE.md` exists and references `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, and `.github/instructions/skills-index.instructions.md`.

If any of these content checks fail and file-write capability exists, run `target-instructions-bootstrap` as a repair step even when the files already exist. If repair is not possible, return `BLOCKED instruction_scaffold_incomplete` with the missing sections.

## Init State Detection

Judge initialization from target repository files, not from chat history or a hidden plugin flag.

Treat the repository as initialized when all of these are true:

- `.github/instructions/project.instructions.md` exists in the target repository.
- It has no unresolved init placeholders such as `<fill:`, `TODO init`, `TBD init`, or `project-specific-name`.
- It is not the untouched neutral scaffold from `target-instructions-bootstrap`; markers such as `Init source: manual scaffold` or `Last verified: unknown` must be replaced before the file counts as initialized.
- It records at least one concrete build, test, check, lint, or dev command, or explicitly says those commands are `unknown` or not applicable after a bounded scan.
- It records concrete project facts for runtime/framework, entrypoints, and module boundaries, or explicitly marks unknown gaps as `unknown` after a bounded scan.

Do not rerun `/init` or `copilot init` merely because a new conversation started or because scaffolds are missing. Rerun the active runtime's official init only when the file is missing, still placeholder-heavy, or lacks the core fact categories above. If facts are current but scaffolds are missing, skip official init and run only the bootstrap skills.

An official init command returning output is not enough. Immediately after running it, write or repair `.github/instructions/project.instructions.md` from official output and bounded repository evidence, then re-check it on disk. If the file is still missing or incomplete, record `official_init_no_write` or `official_init_incomplete` and continue only with bounded manual scan plus local file creation.

## Target Repository State

When this skill runs from an installed plugin, write persistent state into the target repository, never into the plugin installation/cache directory.

Do not copy this plugin repository's instruction files, memory files, specs, or active workflow state into the target repository. Target repositories get their own neutral local files from `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`, then later tasks fill those files with target-specific facts.

- Target project facts: `.github/instructions/project.instructions.md`.
- Target instructions: `.github/instructions/**`, optional `AGENTS.md`, and `CLAUDE.md` when Claude Code compatibility is required.
- Target task memory: `memories/repo/INDEX.md`, `memories/repo/current-workstreams.md`, and compact topic files.
- Target specs: `spec/INDEX.md` and task-specific spec directories.
- This plugin checkout does not keep active target-project `memories/` or `spec/` directories. Installed projects get durable scaffolds from `target-instructions-bootstrap`, `target-memory-bootstrap`, and `target-spec-bootstrap`.
- If target `memories/repo` or `spec` files are absent and persistent recovery may be needed for the current or future MEDIUM/LARGE task, create the minimal skeleton in the target repository.

## Steps

1. Prefer the active runtime's official initializer before substantive analysis only when repository facts are incomplete:
   - Use `/init` when the current runtime exposes it, including Copilot CLI, VS Code Copilot, or Claude Code.
   - From a shell-capable runtime, run `copilot init` directly only when the Copilot CLI command exists.
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
   - `target-instructions-bootstrap`: create missing `.github/instructions/**` and runtime adapters such as optional `AGENTS.md` and Claude Code `CLAUDE.md` when applicable.
   - `target-memory-bootstrap`: create missing `memories/repo/**` skeleton during first substantial plugin use, and later whenever persistent recovery is needed.
   - `target-spec-bootstrap`: create missing `spec/INDEX.md` and `spec/templates/**` during first substantial plugin use, and later before writing any spec.
6. Re-check the `Required First-Use Artifacts` paths on disk. If any required file is still absent, stop with `BLOCKED`; do not downgrade this to `unknown` and do not proceed to dependency, framework, security, or application analysis.
7. Re-check required instruction content. Old short scaffolds must be repaired through `target-instructions-bootstrap`; path existence alone is not enough.
8. Keep instructions short. Do not paste long command output, logs, dependency trees, private hosts, tokens, or PII.
9. Normalize for reuse:
   - Keep the facts generic enough to survive future tasks in the same repository.
   - Mark unresolved facts explicitly as `unknown` instead of guessing.
   - Record only the smallest set of repo facts needed for later routing and verification.
10. Verify:
   - `.github/instructions/project.instructions.md` exists on disk in the target repository.
   - Any bootstrap-created files exist on disk in the target repository and did not overwrite existing project-specific content.
   - `.github/instructions/must.instructions.md` contains `Request Flow`, `Per-Request Hard Gates`, `Shared State Contracts`, `Search Precision`, `Command Output Budget`, `Memory And Spec`, `Agents and Dispatch`, and `Implementation and Verification`.
   - `.github/instructions/must.instructions.md` contains the specialist ask boundary plus `NEEDS_USER_INPUT`/`BLOCKED` fallback rule, `work_mode`, `task_type`, `pm_action`, fixed-string-before-regex search, VS Code `vscode_askQuestions` exact-tool priority, and the first-use scaffold gate.
   - `.github/instructions/skills-index.instructions.md` contains bootstrap routing and the `## Claude Code Skill Names` guidance.
   - When Claude Code compatibility is required, `CLAUDE.md` imports or references the target `.github/instructions/**` files so Claude can load the shared project rules.
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
  - claude_adapter: yes|no|not_applicable|skipped_existing
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
