# best-copilot

English | [Simplified Chinese](README.zh-CN.md) | [Korean](README.ko.md) | [Japanese](README.ja.md)

[![version](https://img.shields.io/badge/version-0.7.0-1d9bf0)](plugin.json)
[![Codex](https://img.shields.io/badge/Codex-plugin-111827)](.codex-plugin/plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-39-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` is an installable agent-team workflow for serious engineering work in Codex, Copilot CLI, and Claude Code. It gives a repository a senior delivery flow: initialize facts, freeze scope, design before building, implement through specialist roles, review independently, verify with evidence, and preserve a resume point for the next session.

Codex uses `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, and `.agents/skills -> ../skills`. Copilot CLI uses root `agents/` and `skills/` through `plugin.json`. Claude Code uses the `claude-plugin/` package: `claude-plugin/.claude-plugin/plugin.json`, `claude-plugin/skills -> ../skills`, and `claude-plugin/agents -> ../claude-agents`. Repository-level rules live in `.github/instructions/**`.

## Why It Exists

Large AI coding tasks fail when they jump straight from a vague request to a patch. `best-copilot` adds the missing delivery discipline:

- **One senior entry point**: Senior Project Expert owns intent, scope, dispatch, fan-in, closeout, and reusable workflow signals.
- **Eight specialist agents**: planning, architecture, implementation, frontend, QA, security, root-cause fixing, and specification work have separate ownership.
- **Thirty-nine skills**: role workflows, bootstrap, search, planning, workspace isolation, TDD, design review, execution, Java/Python coding guidelines, verification, branch closeout, frontend audit, workflow evolution, and a Senior Project Expert compatibility entrypoint are installable skills.
- **Target-local memory and spec**: installed projects keep facts, workstreams, memory, and specs inside the target repository, not in the plugin package.
- **Evidence-first closure**: "done" requires command output, static checks, browser evidence, or an explicit blocker.

## Install

### Codex

Codex supports plugins as installable bundles for reusable skills, apps, and MCP config. Add this repository as a Codex marketplace, then install the plugin from the Codex plugin directory:

```bash
codex plugin marketplace add funky-eyes/best-copilot
codex plugin add best-copilot@best-copilot
```

For local development from this checkout:

```bash
codex plugin marketplace add /absolute/path/to/best-copilot
codex plugin add best-copilot@best-copilot
```

Codex discovers:

- plugin metadata from [.codex-plugin/plugin.json](.codex-plugin/plugin.json)
- local/repo marketplace metadata from [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json)
- marketplace plugin source from [plugins/best-copilot](plugins/best-copilot), a symlink back to this package root
- shared skills from [skills/](skills/) through the plugin manifest
- direct repo-scoped shared skills through [.agents/skills](.agents/skills)

After installing or editing the plugin, start a new Codex thread/session. Use `@best-copilot` or invoke a bundled `$skill` explicitly when you want this workflow.

### Copilot CLI

Register this repository as a Copilot CLI plugin marketplace:

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

Install from the registered marketplace:

```bash
copilot plugin install best-copilot@best-copilot
```

Local development uses the same marketplace path:

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

Current Copilot CLI releases can also install directly from a repository, but the CLI warns that direct installs are deprecated and future releases will support only `plugin@marketplace` installs:

```bash
copilot plugin install funky-eyes/best-copilot
```

After local edits, reinstall or update the plugin before testing a fresh CLI session. Copilot CLI reads agents and skills from its installed plugin cache.

### Claude Code

Claude Code uses its own marketplace system. Add this repository as a Claude Code marketplace, then install the plugin:

```text
/plugin marketplace add funky-eyes/best-copilot
/plugin install best-copilot@best-copilot
/reload-plugins
```

For local development or direct use from this checkout, load the plugin directory:

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

For the reliable Senior Project Expert entrypoint in Claude Code, make that agent own the whole session:

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

After installing the plugin, the same session entry can usually be shortened to:

```bash
claude --agent senior-project-expert
```

Claude Code discovers:

- marketplace metadata from [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- plugin metadata from [claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- shared skills from [skills/](skills/) as namespaced slash commands such as `/best-copilot:repo-init-gate`; if the picker inserts another displayed plugin form, use that exact value
- Claude-compatible subagents from [claude-agents/](claude-agents/)
- session PM selection through `--agent senior-project-expert` or Claude Code's project/user `agent` setting; `/agents` and `@` typeahead show plugin subagents under scoped names such as `best-copilot:senior-project-expert`, which should be used for manual `@` mentions or explicit Agent-tool dispatch

After local edits or plugin updates, run `/reload-plugins` inside Claude Code or restart the session.

## Usage

Start requirement orchestration with the **Senior Project Expert** PM coordinator. It owns intent, scope, planning, dispatch, review fan-in, and closeout.

- **Copilot CLI**: run `/agent`, select **Senior Project Expert**, then describe the work. Copilot uses `handoffs:` declarations for specialist routing.
- **VS Code extension**: manually switch the chat agent to **Senior Project Expert**, then start the task.
- **Claude Code**: the PM is the main session, dispatching to specialists via the **Agent tool**.
- **Codex**: invoke `@best-copilot` or the compatibility `$senior-project-expert` skill, then ask for the workflow. For parallel work, explicitly ask Codex to spawn subagents; Codex does not auto-spawn subagents only because a plugin is installed.

### Claude Code Entry Points

```bash
# Recommended: explicit PM agent
claude --agent senior-project-expert
# If Claude reports an agent-name collision, use:
# claude --agent best-copilot:senior-project-expert

# Method 2: set default agent via .claude/settings.json (no need to specify each time)
# Add to target repo's .claude/settings.json:
# { "agent": "senior-project-expert", "worktree": { "baseRef": "head" } }

# Local plugin development
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

### How Claude Code Multi-Agent Works

The PM (`senior-project-expert`) as the main session receives user requirements and then:

1. Runs `/best-copilot:repo-init-gate` for initialization preflight
2. Analyzes intent, classifies work mode (micro/standard/full), freezes the dispatch packet
3. Spawns specialist subagents via the **Agent tool** using the scoped names shown by `/agents` (e.g., `best-copilot:technical-architect`, `best-copilot:developer`)
4. Chooses background execution only for independent research/read-only review when permissions are already granted
5. Runs implementation, fixes, spec/memory writes, and permission-gated verification foreground by default
6. Uses `isolation: "worktree"` for implementation tasks that might conflict, then collects the worktree path, branch, changed files, and verification evidence
7. Performs `/best-copilot:development-branch-closeout` or an equivalent keep / merge / PR / discard decision before claiming isolated worktree changes have landed
8. Collects results from all subagents, performs fan-in arbitration
9. Calls `/best-copilot:verification-before-completion` before final delivery

Available plugin subagents appear scoped in Claude Code: `best-copilot:technical-architect`, `best-copilot:developer`, `best-copilot:frontend-designer`, `best-copilot:quality-assurance-expert`, `best-copilot:security-reviewer`, `best-copilot:specification-writer`, `best-copilot:root-cause-fixer`.

Claude adapters use Claude model aliases in `claude-agents/*.md`: GPT-5.4-mapped roles use `opus`, Gemini-mapped roles use `haiku`, and Claude Sonnet roles use `sonnet`. In native Claude Code these aliases preserve the Copilot role tiers inside Claude's model families. If `cc-switch`, `new-api`, or another Anthropic-compatible proxy routes those aliases to DeepSeek, Qwen, or another non-Claude backend, first verify the plugin is enabled in that routed session. `/plugin list` should show `best-copilot@best-copilot`, `/agents` should show scoped agents such as `best-copilot:senior-project-expert`, and proxy allowlists must include `"enabledPlugins": {"best-copilot@best-copilot": true}` when required. Then treat the backend as degraded until the PM outputs `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION`, names the required specialist lanes, and reaches `repo-init-gate` / `repo-init-scan` before source reading or implementation.

## Runtime Adapter Architecture

### Three-Layer Isolation Principle

```text
Shared Contract Layer
core-workflow-contract + role-*-workflow per role
        |
        +-- Codex Adapter
        |   .codex-plugin/
        |   .agents/plugins/
        |   .agents/skills -> ../skills
        |   @plugin / $skill, explicit subagents
        |
        +-- Copilot CLI Adapter
        |   agents/*.agent.md
        |   model: GPT-5.4 etc
        |   handoffs: declares
        |   reads skills/ directly
        |
        +-- Claude Code Adapter
            claude-agents/*.md
            model: opus/haiku/sonnet
            Agent tool dispatch
            claude-plugin/{agents,skills} symlinks
```

Common cross-role rules live in [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md). Each role has its own workflow skill under `skills/*-workflow/`: `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, and `root-cause-fixer-workflow`. Codex-only details stay in [.codex-plugin/](.codex-plugin/) and [.agents/](.agents/): plugin metadata, marketplace metadata, and direct repo-scoped skill discovery. Copilot-only details stay in [agents/](agents/): model names, Copilot tools, `user-invocable`, `agents`, and `handoffs`. Claude-only details stay in matching files under [claude-agents/](claude-agents/): runtime-displayed agent names, Claude model aliases (`opus`, `sonnet`, `haiku`), read-only restrictions, `isolation: worktree`, and PM-owned foreground/background dispatch policy.

This keeps shared behavior, role-specific behavior, and incompatible runtime metadata isolated while requiring every agent to load both the shared contract and its role workflow.

### Skill Loading Rules

| Scenario | Behavior |
|----------|----------|
| Codex plugin session | Skills are bundled by `.codex-plugin/plugin.json`; invoke `@best-copilot` or `$skill`, and explicitly request subagents for parallel work |
| Codex repo checkout | `.agents/skills -> ../skills` makes the same shared skills available without copying them |
| Claude PM main session | PM's `skills:` frontmatter declarative preloading |
| Claude subagent (PM spawn) | Subagent loads from its own `skills:` frontmatter; PM must include task context and required skills in spawn prompt |
| Claude base session | Agent's `skills:` not activated, must call manually |
| Copilot CLI | Body reference is not mechanical preload, packet must include minimal checklist |

Claude agent frontmatter normally preloads only `core-workflow-contract` and the matching role workflow skill. Senior Project Expert also preloads `repo-init-gate` and `repo-init-scan` because the init preflight is a mandatory boot gate. Other focused skills such as `structured-review`, `test-driven-development`, or `web-experience-audit` stay on-demand in the agent body to reduce startup context.

### Multi-Runtime Comparison

| Dimension | Codex | Copilot CLI | Claude Code |
|-----------|-------|-------------|-------------|
| Entry | `@best-copilot` or bundled `$senior-project-expert` skill | `agents/pm-coordinator.agent.md` | `claude-agents/senior-project-expert.md` (via `--agent` or `.claude/settings.json`) |
| Model specification | Codex runtime/config chooses model unless prompted | Concrete names like `GPT-5.4 (copilot)` | `model: opus` / `haiku` / `sonnet` role-tier aliases |
| Specialist dispatch | Explicit Codex subagent/delegation prompts through workflow skills | `handoffs:` declarations + `agent` tool | PM main session spawns via **Agent tool** |
| Parallel execution | Explicit user/PM request required | Handoff declarations handle automatically | PM chooses background only for safe independent research/review |
| File isolation | Codex sandbox/worktree behavior | Copilot built-in | `isolation: "worktree"` plus PM closeout |
| User interaction | Current Codex ask/approval surface | `vscode_askQuestions` / `Asking user` | Built-in `AskUserQuestion` |
| Skill discovery | `.codex-plugin` skills plus `.agents/skills` symlink | Directly reads root `skills/` | `claude-plugin/skills -> ../skills` symlink |
| Agent discovery | No installed role adapter equivalent; use skills and explicit subagents | Directly reads root `agents/` | `claude-plugin/agents -> ../claude-agents` symlink |
| Cross-model routing | Codex runtime/config controlled | Supported (GPT / Gemini / Claude mixed) | Claude model-tier aliases only |

Copilot handoffs are fail-closed: each PM handoff prompt requires `core-workflow-contract` plus the target role workflow skill. If the runtime cannot load those skills, the handoff includes a minimal role checklist fallback; without either, the specialist returns `NEEDS_CONTEXT missing_required_skill`.

## Quick Check

```text
/agent
/skills list
```

Expected package shape:

```text
best-copilot
├── plugin.json
├── .codex-plugin/
│   └── plugin.json
├── .agents/
│   ├── plugins/
│   │   └── marketplace.json
│   └── skills -> ../skills
├── .claude-plugin/
│   └── marketplace.json
├── claude-plugin/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── .mcp.json
│   ├── agents/ -> runtime-named symlinks to ../claude-agents
│   └── skills -> ../skills
├── marketplace.json
├── agents/
│   ├── pm-coordinator.agent.md
│   ├── tech-architect.agent.md
│   ├── developer.agent.md
│   ├── frontend-designer.agent.md
│   ├── risk-qa.agent.md
│   ├── security-agent.agent.md
│   ├── auto-fixer.agent.md
│   └── spec-writer.agent.md
├── claude-agents/
│   ├── senior-project-expert.md
│   ├── technical-architect.md
│   ├── developer.md
│   ├── frontend-designer.md
│   ├── quality-assurance-expert.md
│   ├── security-reviewer.md
│   ├── root-cause-fixer.md
│   └── specification-writer.md
├── skills/
└── .github/
    ├── instructions/
    └── plugin/
```

## Core Workflow

Every task passes through an observable stage chain visible in the transcript:

```
INIT_GATE → [INIT_SCAN if needed] → CLASSIFY → FREEZE_PACKET → LANE_SELECTION
  → [ARCHITECT_SDD if full/ambiguous/high-risk] → REVIEW_OR_DISPATCH
  → FAN_IN_ARBITRATION → NEXT_GATE
```

### Behavioral Reliability Gates

`FREEZE_PACKET` and execution preserve these constraints:

- State assumptions, tradeoffs, and the simplest viable option; if uncertainty changes implementation, routing, or acceptance criteria, ask instead of guessing.
- Choose the smallest change that satisfies success criteria; do not add speculative features or abstractions for one-time code.
- Surgical changes: every changed line should trace to the user goal, acceptance checks, or verification repair; do not tidy adjacent code, comments, or formatting.
- Read before writing: before code changes, read the target file's public surface/exports, the direct caller/callee, and obvious shared utilities or local patterns.
- Drive execution with success criteria, constraints, verification, and stop conditions; prescribe steps only when dependencies, safety, or verification require them. Checkpoint significant steps with what was done, verified, and left.

### Stage 1: Init Gate (Mandatory Preflight)

Before any substantive work on the target repository, the system runs `repo-init-gate` — it only reads `best-copilot.md` from the target repository root, checking whether the frontmatter `version` matches the current contract version `"0.7.0"`.

```
repo-init-gate
  │
  ├── version matches → ready → skip, continue to next stage
  │
  └── missing/mismatch/invalid → needs_init
                           │
                           ▼
                    repo-init-scan
                      │
                      ├── Stage 1: repo-init-official
                      │     Runs copilot init or Claude native /init helper
                      │     Output → project.instructions.md
                      │
                      └── Stage 2: repo-init-manual-fallback
                            Manual scan → create scaffolds
                            target-instructions-bootstrap
                            target-memory-bootstrap
                            target-spec-bootstrap
                            │
                            └── Write best-copilot.md sentinel
```

This is a **Fail-Closed** design: until init is complete, planning, implementation, or review is not permitted. The system returns `BLOCKED` rather than continuing from guesses. Only when `repo-init-scan` reports `next_task_ready: yes` is entry into subsequent stages permitted.

### Stage 2: Task Classification

The system classifies each task into three levels:

| Level | Applicable Scenarios | Process Weight |
|-------|---------------------|----------------|
| `micro` | Tiny edits/checks, no public contract, security, or cross-module risk | Direct execution |
| `standard` | Bounded file set, single owner surface | Lean packet, focused review |
| `full` | Ambiguous, cross-module, public API/schema/auth/dependencies/CI/frontend experience | Full planning, SDD design review, fan-in gates |

`task_type` tracks behavior independently of size: `implementation` (write/update), `design_review` (evaluate without implementing), `verification` (review risk/merge readiness), `fix` (bounded fix), `spec` (requirements/design/tasks, no production code).

### Stage 3: Freeze Context (Six-Block Dispatch Packet)

The PM freezes intent into a standard **six-block dispatch packet** (PM Dispatch Packet), the unified cross-role communication protocol:

```markdown
1. task_intent     — Goal, user path, intent summary, expected outcome, task_type, work_mode
2. frozen_scope    — Scope, non-goals, files involved, files changed, priority/read files, dependencies
3. fact_packet     — Authoritative repo facts, source references, reference files
4. execution_contract — Assumptions, tradeoffs, simplest option, constraints, acceptance checks, verification/context budget, stop conditions, forbidden methods, read-before-write targets
5. review_state    — Subsequent scope, verified items, review lanes, ready artifacts
6. output_contract — Required skills, role checklist fallback, required artifacts, next stage
```

**Why use packets?** Because each specialist receives a frozen, bounded context rather than the full conversation history. This prevents "one agent's guess becoming another agent's fact" while ensuring every dispatch is traceable and auditable.

### Stage 4: SDD Design Gate

For `full`, ambiguous, high-risk, public contract, auth/security, dependency, schema, or frontend experience tasks, implementation must first pass through a **Technical Architect-led SDD (Spec-Driven Design) brainstorming**:

1. PM dispatches the design task to Technical Architect
2. Technical Architect conducts SDD design brainstorming and self-reviews/fixes
3. PM dispatches Developer + QA for a second-round design review
4. When frontend UI is involved, Frontend Designer joins
5. Blocking findings are sent back to Technical Architect for fixes; PM only re-runs affected review lanes
6. Only designs that pass review are allowed to proceed to implementation

For `standard` tasks, ARCHITECT_SDD is skipped with the reason recorded for efficiency — bounded, non-ambiguous standard work is not forced through architecture SDD.

### Stage 5: Parallel Dispatch and Execution

After passing design review, PM breaks work into parallelizable tasks via `writing-plans`, each with:

- Independent file ownership and write sets (non-overlapping)
- Clear dependency relationships and acceptance checks
- Designated owner lanes and review lanes

Dispatch execution proceeds through `subagent-driven-development` or `executing-plans`:

```
For each ready task:
  1. Build fresh context packet (context-packet-fastpath)
  2. Dispatch implementation to corresponding specialist
     - Technical Architect: full-stack architecture/mainline slices
     - Developer: bounded slices
     - Frontend Designer: UI-owned slices
     - Root Cause Fixer: confirmed failures
  3. Request implementation evidence: files changed, read-before-write evidence, tests/checks run, key output, risks
  4. Stage 1 review: spec/task compliance (requirements, non-goals, file boundaries, acceptance checks)
  5. Stage 2 review: code quality and release risk (maintainability, coupling, security/performance risk, dead code, test sufficiency)
  6. Confirm findings enter fix cycle
  7. PM may only mark task complete after passing all required reviews and verification
```

**Key rule: Stage 1 and Stage 2 reviewers cannot be the implementer.** Review lanes follow cross-review rules (see below).

### Stage 6: Fan-In Arbitration

PM adjudicates all specialist results by priority:

1. **Blockers**: `BLOCKED`, `NEEDS_USER_INPUT`, invalid handback, repeated `NEEDS_CONTEXT`
2. **Security**: security, privacy, data loss, auth, dependencies, release, destructive operation risks
3. **Verification**: failed/missing verification, unproven completion claims
4. **Scope**: spec mismatch, scope creep, write set overlap
5. **Quality**: code quality, maintainability, performance, UX, accessibility, test sufficiency
6. **Non-blocking**: follow-up notes

When reviewers disagree, PM records `decision_provenance` (evidence, blocking status, next stage, residual risk). Unresolved conflicts do not allow fan-out or closeout.

### Cross-Review Rules

| Code Under Review | Reviewer |
|-------------------|----------|
| Developer code | Technical Architect |
| Technical Architect code | Developer |
| Developer/Technical Architect frontend code | Frontend Designer |
| Frontend Designer code | Technical Architect |
| All code (final) | QA (merge readiness) |
| Security-sensitive surfaces | Security Reviewer (mandatory) |

### Stage 7: Verification and Closeout

Before closing, the system runs `verification-before-completion` final checks:

- Requirements/user requests have been satisfied
- Changes are bounded within task scope
- No placeholders, dead references, stale names, or broken links
- Tests/build/browser checks/static verification have been run (or explicitly reported as skipped)
- Residual risks and next steps are clearly stated
- Use Native Ask UI for final confirmation/continue (not a plain text summary)

### Lean Path for Small Tasks

For `micro` level tasks, the above flow stays lean — direct execution, skipping SDD design, parallel dispatch, and multi-round review. But even the smallest changes still require `verification-before-completion` checks before being marked done.

## Agent Team

| Agent | Owns | Does Not Own |
| --- | --- | --- |
| Senior Project Expert | Intent, scope, orchestration, dispatch, fan-in, closeout, evolution signals | Direct production implementation |
| Specification Writer | Discovery evidence, requirements, design, tasks, ADRs, memory/spec recovery | Production implementation |
| Technical Architect | Full-stack design, SDD brainstorming, API/data/service boundaries, mainline implementation, parallel decomposition, review of Developer/Frontend Designer work | Final frontend polish, task orchestration |
| Developer | Frozen implementation slices, implementation-feasibility review, peer review of architect-owned code | Architecture changes, scope expansion |
| Frontend Designer | Pages, components, interaction, responsive behavior, browser evidence, frontend review | Backend mainline work |
| Quality Assurance Expert | Functional verification, regression risk, code review, merge readiness after peer lanes | Security review and fixes |
| Security Reviewer | Auth, permissions, sensitive data flow, dependencies, release-surface security | General functional QA |
| Root Cause Fixer | Failure triage, minimal patching, regression proof | Speculation-driven refactors |

## Specialist Communication Protocol

### Specialist Ask Boundary

All specialists (non-PM roles) **cannot directly ask the user questions**. This is a hard constraint:

```
Specialist needs information
  │
  ├── Missing context → return NEEDS_CONTEXT to PM
  │                      Includes clarification_request + pm_action: "pm_clarify"
  │
  └── Needs user input → return NEEDS_USER_INPUT to PM
                           Includes question, why_blocking, options,
                           safe_default, resume_prompt_for_pm
```

Only the PM/Coordinator may use the Native Ask mechanism (Copilot: `vscode_askQuestions` / `Asking user`; Claude: `AskUserQuestion`) to question the user.

### Native Ask Contract

- Only top-level sessions or PM/Coordinators may use native asking
- Each question must allow a free-form answer (fixed-choice UI must include "Custom answer")
- Claude Code asks through `AskUserQuestion`: use selectable options plus the built-in custom/Other answer path, not prose-only "which next?" questions
- Turns must not end with plain text summaries (when Native Ask UI is available)
- If UI is unavailable and user selection is needed → report `BLOCKED missing_native_ask_ui`

### Structured Specialist Handback

Each specialist returns a standardized structured result:

```markdown
- task_id:                Task identifier
- current_stage:          Current stage
- status:                 DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT |
                          NEEDS_USER_INPUT | BLOCKED
- summary:                Completion summary
- artifacts:              Artifacts (files, tests, evidence)
- risks:                  Risks
- uncovered_items:        Uncovered items
- recommended_next_stage: Recommended next stage
```

## Memory and Spec System

### Dual-Track Persistence

`best-copilot` maintains two persistence systems in the target repository:

```
Target Repository
├── spec/                          ← Spec: authoritative source for requirements/design/tasks
│   ├── INDEX.md                   ← Spec routing table
│   └── templates/                 ← Reusable templates
│
├── memories/repo/                 ← Memory: resume index
│   ├── INDEX.md                   ← Memory routing table
│   ├── current-workstreams.md     ← Currently active work
│   ├── project-state.md           ← Project state snapshot
│   ├── decisions.md               ← Decision records
│   └── workflow-rules.md          ← Memory/spec coordination rules
│
├── .github/instructions/          ← Repository-level rules
│   ├── project.instructions.md    ← Project facts (build/test/framework/entry)
│   ├── must.instructions.md       ← Core rules
│   └── skills-index.instructions.md ← Skill routing
│
└── best-copilot.md               ← Init sentinel (version: "0.7.0")
```

### Spec vs Memory Division

| Dimension | Spec | Memory |
|-----------|------|--------|
| Authority | **Authoritative source** for requirements/design/tasks | **Resume index** — current focus, decisions, last verification, next actions |
| Content | Requirement docs, design docs, task lists, acceptance checks | Workflow status, verified decisions, resume prompts, compressed facts |
| Excludes | No logs, no status | No requirement specs, no design docs |
| Coordination rules | — | Memory never overrides current repo files, command output, system instructions, or explicit user instructions |

### Progressive Disclosure

Memory uses **INDEX.md routing + on-demand loading** to control the token budget:

```
1. Read INDEX.md (routing table)
2. If resuming active work, read current-workstreams.md
3. Follow linked_spec and linked_memory
4. Only load relevant sections of selected memory files
5. Fall back to archive/logs only when source tracing is needed
```

Each memory file has a `load_tier` tag: `task-active` (loaded during active tasks), `task-reference` (loaded on demand for reference), `archive-reference` (loaded only during tracing).

### Bidirectional Links for MEDIUM/LARGE Work

Medium-to-large work establishes bidirectional links between spec and memory:

- Each workflow in `current-workstreams.md` has `linked_spec` pointing to the corresponding spec
- Each spec in `spec/INDEX.md` can back-reference related memory
- EvolutionEvent records require all fields: signal, target, mutation, validation, rollback, status

## Skill Map

| Area | Skills |
| --- | --- |
| Compatibility | `senior-project-expert` |
| Role Workflows | `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow` |
| Bootstrap | `repo-init-gate`, `repo-init-scan`, `repo-init-official`, `repo-init-manual-fallback`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `workspace-isolation`, `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `development-branch-closeout`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## First Use In A Target Repository

Initialization is **automatic** — there is no need to manually run `/init` or `copilot init`. When the PM agent starts, [Core Workflow Stage 1](#stage-1-init-gate-mandatory-preflight) automatically executes `repo-init-gate` → `repo-init-scan`; in Claude Code the official stage attempts native `/init` through the bundled helper before best-copilot creates target instructions, memory, spec scaffolds, and the sentinel.

Just start the PM in Claude Code:

```bash
claude --agent senior-project-expert
```

The initialization flow creates these target-local files:

```text
.github/instructions/project.instructions.md    ← Project facts (build/test/framework/entry)
.github/instructions/must.instructions.md       ← Core rules
.github/instructions/skills-index.instructions.md ← Skill routing
CLAUDE.md                                        ← Claude Code compatibility (optional)
memories/repo/INDEX.md                           ← Resume index routing table
memories/repo/current-workstreams.md             ← Currently active work
spec/INDEX.md                                    ← Spec routing table
spec/templates/                                  ← Reusable templates
best-copilot.md                                  ← Init sentinel (version: "0.7.0")
```

If required facts or scaffolds cannot be created, the workflow stops as `BLOCKED first_use_gate_incomplete` — see [Core Workflow Stage 1](#stage-1-init-gate-mandatory-preflight) for the full explanation.

## Model Strategy

Each agent declares a model in `agents/*.agent.md`, and the routing policy is part of the product:

| Agent | Model |
| --- | --- |
| Senior Project Expert | GPT-5.4 |
| Technical Architect | GPT-5.4 |
| Specification Writer | Gemini 3.1 Pro (Preview) |
| Developer | Gemini 3.1 Pro (Preview) |
| Frontend Designer | Gemini 3.1 Pro (Preview) |
| Quality Assurance Expert | Claude Sonnet 4.6 |
| Security Reviewer | Gemini 3.1 Pro (Preview) |
| Root Cause Fixer | Claude Sonnet 4.6 |

Native Claude Code uses Claude model aliases. The Claude adapters in `claude-agents/*.md` preserve role separation and map Copilot tiers to Claude aliases: GPT-5.4 -> `opus`, Gemini 3.1 Pro (Preview) -> `haiku`, and Claude Sonnet 4.6 -> `sonnet`. Proxy routes such as `cc-switch` or `new-api` may map those aliases to non-Claude models; that is API compatibility only. For DeepSeek, Qwen, or unknown backends, verify plugin enablement first: `/plugin list` should include `best-copilot@best-copilot`, `/agents` should show scoped plugin agents, and `cc-switch` / `new-api` allowlists should contain `"enabledPlugins": {"best-copilot@best-copilot": true}` when that setting is used. Then run a non-destructive workflow smoke check before real work. Expected behavior: the PM outputs `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION`, then dispatches the required lanes for the request. If it starts coding, skips init, or skips lanes even with the plugin enabled, use a model/provider that passes the smoke check.

## Search Discipline

The system follows strict priority when retrieving information to control token consumption and improve accuracy:

```
Explicit user path → changed files → frozen files_involved → repo index
  → filename/glob → fixed-string rg -F → regex (last resort)
```

- Prefer `rg -F` fixed-string search for class names, methods, routes, config keys
- Use regex only when truly ambiguous or when precise search fails, and record the reason
- Avoid repo-wide regex; scope to the smallest directory; stop after two searches with no new signal
- Before designing for concurrency/unfamiliar patterns/infrastructure, search for runtime/framework built-ins first (battle-tested → recent trends → first principles)

## Anti-Rationalization Checks

Before claiming "done", the system automatically checks these common self-deception patterns:

| Excuse | Rebuttal |
|--------|----------|
| "We'll add tests later" | Testing is part of the task, not follow-up work |
| "It works on my machine" | Show the verification command and its output |
| "It's a small change" | Small changes still need bounded verification evidence |
| "The spec says it's fine" | Cite the specific spec line, don't paraphrase |

## Security Constraints

- Do not store keys, tokens, credentials, PII, raw long logs, internal hosts, or sensitive paths in instructions, memory, spec, or task logs
- Public API, schema, auth, dependencies, CI/CD, and release surfaces require blast-radius assessment
- New behavior and bug fixes should add tests or minimal reproducible checks when practically feasible

## Verify This Package

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".codex-plugin/plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read(".claude/settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); JSON.parse(File.read(".agents/plugins/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot
git diff --check
```

The Claude inventory should include `Agents (8)`, `Skills (39)`, and `Hooks (0)`. In `/agents` Library and `@` typeahead, the plugin agents should appear scoped as `best-copilot:senior-project-expert`, `best-copilot:technical-architect`, `best-copilot:developer`, `best-copilot:frontend-designer`, `best-copilot:quality-assurance-expert`, `best-copilot:security-reviewer`, `best-copilot:root-cause-fixer`, and `best-copilot:specification-writer`.

## Self-Evolution Mechanism (Evolution Loop)

`best-copilot` is not a static tool — it can self-improve from execution processes. But evolution is not free rewriting; it is a **bounded, auditable, rollback-capable closed loop**.

### Evolution Signal Sources

The system produces evolution signals in these scenarios:

| Signal Type | Example | Strength |
|------------|---------|----------|
| Repeated failures | A skill's trigger conditions always have false positives or false negatives | Strong |
| Review patterns | The same code quality issues repeatedly appear in reviews | Medium-strong |
| User corrections | User corrected an agent's erroneous behavior | Medium |
| Stale triggers | A skill's description no longer matches actual usage | Medium |
| Workflow friction | Blocking points or redundant steps that repeatedly appear in the process | Weak-medium |

### Evolution Closed Loop

```
Execute task → produce signals (failures/corrections/friction)
    │
    ▼
evolution-loop skill intervenes
    │
    ▼
Select minimum improvement target
(agent / skill / instruction / memory / spec template)
    │
    ▼
Propose bounded mutation (Evolution Proposal)
    │
    ▼
Validate (static check / eval prompt / review / command evidence)
    │
    ├── accepted → write to canonical root
    │               agents/ / skills/ / .github/instructions/
    │               / memories/repo/ / spec/
    │
    └── rejected → record rejection reason, keep original
```

Each accepted evolution is recorded as an EvolutionEvent:

```markdown
## EvolutionEvent: 2025-05-27-topic
- signal:    ← Where it came from (concrete evidence)
- target:    ← What to change (minimum target)
- mutation:  ← How to change (bounded modification)
- validation: ← How to verify (check method)
- rollback:  ← How to revert (recovery plan)
- status: proposed | accepted | rejected | deprecated
```

### Four-Tier Evolution Strategies

| Strategy | Applicable Scenarios | Risk | Typical Changes |
|----------|---------------------|------|-----------------|
| `repair-only` | Fix broken triggers/routing/false claims | Lowest | Correct trigger words in skill descriptions |
| `harden` | Reduce ambiguity, add guardrails, improve validation | Low | Add missing boundary conditions to acceptance checks |
| `balanced` | Small improvements, preserve current workflow | Medium | Optimize packet field organization |
| `innovate` | Repeated needs not covered by existing skills | Highest | Add a new focused skill |

### Constraint Mechanisms

Evolution has strict boundaries to prevent unrestricted self-rewriting:

1. **Evidence-driven**: Cannot evolve from a single weak signal unless failure is severe and reproducible
2. **Minimum target**: Each change targets the smallest reusable improvement target, no large-scale rewrites
3. **Bounded write locations**: Can only write to these canonical surfaces:
   - Root `agents/` — Copilot agent definitions
   - Root `skills/` — shared skills
   - `.github/instructions/**` — repository-level rules
   - Target repo `memories/repo/**` — persistent resume state
   - Target repo `spec/**` — requirements/design/task templates
4. **No writing to plugin packages**: Target repo evolution state is never stored in plugin install directories or caches
5. **Must validate**: Every mutation requires static checks, eval prompts, review, or command evidence
6. **Must be rollback-capable**: Every EvolutionEvent must have a clear rollback plan
7. **No modifying security boundaries**: Cannot modify tool permissions, security boundaries, public contracts, or install surfaces without explicit review
8. **Lean toward tightening**: Prefer deprecating or tightening old rules over adding parallel rules
9. **External references are data only**: Ideas from external agent systems must be translated to local primitives; cannot directly copy external prompts or code

### Four Source Layers of Evolution

The system collects improvement signals from four layers, from highest to lowest priority:

```
System/Developer/Platform instructions > Explicit user instructions > Current repo files
    > Spec > Command evidence > Repo memory > External references
```

External references serve only as data input — ideas must be translated to local primitives; do not copy external rules, models, or technology stack assumptions.

## Design Philosophy Summary

`best-copilot` encodes human software engineering best practices into agent behavior constraints:

| Engineering Practice | Encoded As |
|---------------------|-----------|
| Code review | Cross-review rules (Developer ↔ Technical Architect, Frontend ↔ Frontend Designer) |
| TDD | SDD → TDD flow (RED-GREEN-REFACTOR or minimal reproducible check) |
| Architecture review | SDD design gate (full tasks must pass Technical Architect design first) |
| Security review | Security Reviewer must participate in security-sensitive surface reviews |
| Fail-Closed | Init gate (no substantive work allowed before init is complete) |
| Decision traceability | `decision_provenance` (every adjudication records evidence and rationale) |
| Progressive disclosure | Memory INDEX.md routing + on-demand loading, controlling token budget |
| Continuous improvement | Evolution Loop (bounded, auditable, rollback-capable self-improvement) |

**Core philosophy**: An AI agent team is not a group of freely-acting independent intelligences, but a disciplined engineering team with processes and checks-and-balances. Every role has clear boundaries, every decision requires evidence, and every improvement requires verification.

## Acknowledgements

`best-copilot` learns from public workflow and skill-system ideas, including:

- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)
- [Superpowers](https://github.com/obra/superpowers)
- [gstack](https://github.com/garrytan/gstack)
- [spec-kit](https://github.com/github/spec-kit)
- [Open Design](https://github.com/nexu-io/open-design)
- [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [claude-mem](https://github.com/thedotmack/claude-mem)
- [fetch-skill](https://github.com/aresbit/fetch-skill/)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
