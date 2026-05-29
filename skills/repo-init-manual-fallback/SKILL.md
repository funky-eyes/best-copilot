---
name: repo-init-manual-fallback
description: "Use inside repo-init-scan after the official stage whenever scaffold verification, bounded repair, or `best-copilot.md` rewrite is still needed."
---

# Repo Init Manual Fallback

Use this stage inside `repo-init-scan` whenever scaffold verification, bounded repair, or `best-copilot.md` rewrite is still needed. After official init succeeds, this stage still owns the final scaffold verification barrier and sentinel rewrite.

## Boundary

- This stage is fail-closed. Do not continue to requirements analysis, planning, dependency/framework changes, security rewrites, or implementation until the required files have been created or a `BLOCKED` result has been returned.
- Reading package/build files is allowed only as bounded evidence for creating `.github/instructions/project.instructions.md`.
- Write persistent state into the target repository, never into the plugin installation/cache directory.
- Loading this skill or the bootstrap skills is not enough. Success requires actual create/repair operations in the target repository followed by path and content checks on disk.
- If `target-instructions-bootstrap`, `target-memory-bootstrap`, or `target-spec-bootstrap` cannot be invoked mechanically, read their `SKILL.md` templates and perform the documented create-only repair inline. Do not skip a missing scaffold because skill invocation was unavailable.

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

`best-copilot.md` is not a neutral scaffold. It is the verified-init sentinel for contract version `0.6.0` and must be written only after the other required artifacts and content checks pass.

Never write project descriptions, task summaries, or markdown headings into `best-copilot.md`. A file like `# Best Copilot Sentinel` plus a project summary is invalid, even if it mentions the right version. The only valid sentinel content is the exact frontmatter block shown below.

## Required Content Checks

- `.github/instructions/must.instructions.md` contains `## Request Flow`, `## Per-Request Hard Gates`, `### PM Native Ask Trigger Gate`, `## Shared State Contracts`, `## Search Precision`, `## Command Output Budget`, `## Memory And Spec`, `## Agents and Dispatch`, and `## Implementation and Verification`.
- That same file contains the specialist ask boundary plus `NEEDS_USER_INPUT` / `BLOCKED` fallback rule, `work_mode`, `task_type`, `pm_action`, fixed-string-before-regex search, VS Code `vscode_askQuestions` exact-tool priority, and the first-use scaffold gate.
- `.github/instructions/skills-index.instructions.md` contains bootstrap routing and the `## Claude Code Skill Names` guidance.
- When Claude Code compatibility is required, `CLAUDE.md` references `.github/instructions/project.instructions.md`, `.github/instructions/must.instructions.md`, and `.github/instructions/skills-index.instructions.md`.

## Steps

1. Start from the current `.github/instructions/project.instructions.md` when it already exists and passed the official-init success bar:
   - Reuse that file as the primary fact packet.
   - Scan only the missing fact categories, missing scaffold surfaces, or unresolved `unknown` gaps that still block verification.
2. Otherwise do a bounded manual scan:
   - Read `CLAUDE.md` first when `repo-init-official` created or updated it through Claude native `/init`; treat it as official initializer evidence, but still verify facts against repository files before recording them.
   - Read `README*`, package/build files, CI files, app entrypoints, test directories, and existing `.github/instructions/project.instructions.md`.
   - Search only for build/test/dev entrypoints and major module boundaries.
   - Record unresolved facts as `unknown` instead of guessing.
3. Create or repair `.github/instructions/project.instructions.md` with: `Project Facts`, `Build and Test Commands`, `Runtime and Entry Points`, `Module Boundaries`, `Known Unknowns`, `Verification Notes`, and `Init Status`.
4. Replace neutral scaffold markers with `Init source: manual_fallback|official_init_plus_manual_fallback` and a real verification timestamp or bounded-scan note.
5. Ensure `## Init Status` contains:
   - `Init ready: yes|no`
   - `Required artifacts verified: yes|no`
   - `Bootstrap contract version: 0.6.0`
   - `Last full verification: <timestamp-or-bounded-scan-note>`
   - `Reentry rule: best-copilot-version-sentinel-first`
6. Initialize missing target-local scaffolds in this order:
   - `target-instructions-bootstrap`
   - `target-memory-bootstrap`
   - `target-spec-bootstrap`
   Loading those skills only makes their templates available; the caller must still create or repair the listed target files before continuing.
7. Re-check the required artifact paths on disk.
8. Re-check the required instruction content.
9. After the other required artifacts and content checks pass, write the target root `best-copilot.md` exactly as:

```md
---
version: "0.6.0"
---
```

10. Verify:
   - `.github/instructions/project.instructions.md` exists and is not placeholder-heavy.
   - The `## Init Status` block contains `Bootstrap contract version: 0.6.0`.
   - The target root `best-copilot.md` exists and exactly matches the expected frontmatter sentinel.
   - Any bootstrap-created files exist on disk and did not overwrite project-specific content.

## Output

```markdown
## Repo Init Manual Fallback
- status: success|blocked
- required_artifacts_verified: yes|no
- sentinel_written: yes|no
- next_task_ready: yes|no
```
