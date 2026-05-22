# best-copilot

English | [Simplified Chinese](README.zh-CN.md) | [Korean](README.ko.md) | [Japanese](README.ja.md)

[![version](https://img.shields.io/badge/version-0.4.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-35-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` is an installable agent team for serious engineering work in Copilot CLI and Claude Code. It gives a repository a senior delivery flow: initialize facts, freeze scope, design before building, implement through specialist roles, review independently, verify with evidence, and preserve a resume point for the next session.

Copilot CLI uses root `agents/` and `skills/` through `plugin.json`. Claude Code uses `.claude-plugin/plugin.json`, root `skills/`, and lowercase-hyphen adapters in `claude-agents/`. Repository-level rules live in `.github/instructions/**`.

## Why It Exists

Large AI coding tasks fail when they jump straight from a vague request to a patch. `best-copilot` adds the missing delivery discipline:

- **One senior entry point**: Senior Project Expert owns intent, scope, dispatch, fan-in, closeout, and reusable workflow signals.
- **Eight specialist agents**: planning, architecture, implementation, frontend, QA, security, root-cause fixing, and specification work have separate ownership.
- **Thirty-five skills**: role workflows, bootstrap, search, planning, workspace isolation, TDD, design review, execution, Java/Python coding guidelines, verification, branch closeout, frontend audit, and workflow evolution are installable skills.
- **Target-local memory and spec**: installed projects keep facts, workstreams, memory, and specs inside the target repository, not in the plugin package.
- **Evidence-first closure**: “done” requires command output, static checks, browser evidence, or an explicit blocker.

## Install

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
claude --plugin-dir /absolute/path/to/best-copilot
```

For multi-agent teams, enable Claude Code agent teams before launch. Agent teams are experimental in Claude Code and require Claude Code v2.1.32 or later:

```bash
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --plugin-dir /absolute/path/to/best-copilot
```

Claude Code discovers:

- marketplace metadata from [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- plugin metadata from [.claude-plugin/plugin.json](.claude-plugin/plugin.json)
- shared skills from [skills/](skills/) as `/best-copilot:<skill-name>`
- Claude-compatible subagents from [claude-agents/](claude-agents/)
- default main agent from [settings.json](settings.json), currently `best-copilot:senior-project-expert`

After local edits or plugin updates, run `/reload-plugins` inside Claude Code or restart the session.

## Usage

Start requirement orchestration with the coordinator agent in [agents/pm-coordinator.agent.md](agents/pm-coordinator.agent.md). This agent appears as **Senior Project Expert** and owns intent, scope, planning, dispatch, review fan-in, and closeout.

- **Copilot CLI**: run `/agent`, select **Senior Project Expert**, then describe the work.
- **VS Code extension**: manually switch the chat agent to **Senior Project Expert**, then start the task.
- **Claude Code**: start with `claude --plugin-dir /absolute/path/to/best-copilot`; the plugin default agent is `best-copilot:senior-project-expert`. Use `/agents` to inspect plugin agents and `/best-copilot:<skill-name>` to invoke a skill directly.

Claude Code multi-agent prompt example:

```text
Create an agent team for this task. Use best-copilot:senior-project-expert as the lead.
Spawn teammates using best-copilot:technical-architect, best-copilot:developer,
best-copilot:quality-assurance-expert, and best-copilot:security-reviewer
where their scopes apply. Keep write sets non-overlapping,
prevent self-review, and report command evidence before closeout.
For each teammate, invoke /best-copilot:core-workflow-contract plus its
matching role workflow skill, or include the minimal role checklist fallback.
```

Claude Code can match the Copilot-style multi-agent workflow through plugin agents, skills, and agent teams. It does not reproduce Copilot's cross-provider model routing: Claude adapters use `model: inherit`, so choose the Claude model for the session with `/model`, `--model`, or your normal Claude Code settings.

## Runtime Adapter Architecture

Common cross-role rules live in [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md). Each role has its own workflow skill under `skills/*-workflow/`: `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, and `root-cause-fixer-workflow`. Copilot-only details stay in [agents/](agents/): model names, Copilot tools, `user-invocable`, `agents`, and `handoffs`. Claude-only details stay in matching files under [claude-agents/](claude-agents/): scoped plugin agent names, `model: inherit`, read-only restrictions, and the agent-team rule that `skills` frontmatter is not applied to teammates.

This keeps shared behavior, role-specific behavior, and incompatible runtime metadata isolated while requiring every agent to load both the shared contract and its role workflow.

Claude agent frontmatter preloads only `core-workflow-contract` and the matching role workflow skill. Focused skills such as `structured-review`, `test-driven-development`, or `web-experience-audit` stay on-demand in the agent body to reduce startup context.

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
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
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
│   ├── pm-coordinator.agent.md
│   ├── tech-architect.agent.md
│   ├── developer.agent.md
│   ├── frontend-designer.agent.md
│   ├── risk-qa.agent.md
│   ├── security-agent.agent.md
│   ├── auto-fixer.agent.md
│   └── spec-writer.agent.md
├── skills/
└── .github/
    ├── instructions/
    └── plugin/
```

## Workflow

```text
User request
  -> init or repo fact check
  -> Senior Project Expert freezes scope
  -> brainstorming or direct planning
  -> requirements / design / tasks when risk is non-trivial
  -> design review before implementation
  -> specialist implementation
  -> cross review
  -> QA / security / frontend verification
  -> closeout with evidence and resume point
```

For small scoped edits, the flow stays light. For cross-module work, public contracts, dependencies, auth, release surfaces, frontend experience, or ambiguous product direction, the heavier gates are intentional.

## Agent Team

| Agent | Owns | Does Not Own |
| --- | --- | --- |
| Senior Project Expert | Intent, scope, orchestration, dispatch, fan-in, closeout, evolution signals | Direct production implementation |
| Specification Writer | Discovery evidence, requirements, design, tasks, ADRs, memory/spec recovery | Production implementation |
| Technical Architect | Backend/full-stack design, API/data/service boundaries, mainline implementation, architecture review | Frontend polish, small parallel slices |
| Developer | Frozen implementation slices, implementation-feasibility review, peer review of architect-owned code | Architecture changes, scope expansion |
| Frontend Designer | Pages, components, interaction, responsive behavior, browser evidence | Backend mainline work |
| Quality Assurance Expert | Functional verification, regression risk, code review, merge readiness | Security review and fixes |
| Security Reviewer | Auth, permissions, sensitive data flow, dependencies, release-surface security | General functional QA |
| Root Cause Fixer | Failure triage, minimal patching, regression proof | Speculation-driven refactors |

## Skill Map

| Area | Skills |
| --- | --- |
| Role Workflows | `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow` |
| Bootstrap | `repo-init-scan`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `workspace-isolation`, `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `development-branch-closeout`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## First Use In A Target Repository

Before the first meaningful task in a new repository, let the active runtime inspect the project:

```text
/init
```

In Copilot CLI, the shell command is also available:

```bash
copilot init
```

Then start substantial work with **Senior Project Expert** / `best-copilot:senior-project-expert`. It should normalize useful facts into the target repository, create missing local scaffolds, and verify those files before substantive planning or implementation.

Target-local state belongs to the target repository:

```text
.github/instructions/project.instructions.md
.github/instructions/must.instructions.md
.github/instructions/skills-index.instructions.md
CLAUDE.md  # when Claude Code compatibility is needed
memories/repo/INDEX.md
memories/repo/current-workstreams.md
spec/INDEX.md
spec/templates/
```

If required facts or scaffolds cannot be created, the workflow should stop as `BLOCKED first_use_gate_incomplete` instead of continuing from guesses.

## Model Strategy

The roles are not renamed copies of one generic assistant. Each agent declares a model in `agents/*.agent.md`, and the routing policy is part of the product:

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

Claude Code only runs Claude models. The Claude adapters in `claude-agents/*.agent.md` preserve role separation and use `model: inherit` so the active Claude Code session controls the actual model.

## Verify This Package

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.agent.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
git diff --check
```

## Evolution Rules

`best-copilot` does not let agents rewrite themselves freely. Workflow changes should come from verified signals: failed commands, repeated review findings, user corrections, stale routing, or concrete installation/runtime drift.

Accepted improvements should be small, reversible, and written to the owning surface: root `agents/`, root `skills/`, `.github/instructions/**`, or target-local `memories/repo/**` and `spec/**`.

## Acknowledgements

`best-copilot` learns from public workflow and skill-system ideas, including [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent), [Superpowers](https://github.com/obra/superpowers), [gstack](https://github.com/garrytan/gstack), [spec-kit](https://github.com/github/spec-kit), [Open Design](https://github.com/nexu-io/open-design), [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill), [claude-mem](https://github.com/thedotmack/claude-mem), [fetch-skill](https://github.com/aresbit/fetch-skill/), [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills), [Evolver](https://github.com/EvoMap/evolver), and Tongdun Java/Python coding-guideline skills. The implementation here is a dual Copilot CLI and Claude Code plugin layout with its own agents, skills, routing rules, and verification gates.
