# best-copilot

English | [Simplified Chinese](README.zh-CN.md) | [Korean](README.ko.md) | [Japanese](README.ja.md)

[![version](https://img.shields.io/badge/version-0.2.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-23-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` is an installable Copilot CLI agent team for serious engineering work. It gives a repository a senior delivery flow: initialize facts, freeze scope, design before building, implement through specialist roles, review independently, verify with evidence, and preserve a resume point for the next session.

It is Copilot CLI first. Root `agents/` and `skills/` are exposed through `plugin.json`; repository-level rules live in `.github/instructions/**`.

## Why It Exists

Large AI coding tasks fail when they jump straight from a vague request to a patch. `best-copilot` adds the missing delivery discipline:

- **One senior entry point**: Senior Project Expert owns intent, scope, dispatch, fan-in, closeout, and reusable workflow signals.
- **Eight specialist agents**: planning, architecture, implementation, frontend, QA, security, root-cause fixing, and specification work have separate ownership.
- **Twenty-three skills**: bootstrap, search, planning, TDD, design review, execution, verification, frontend audit, and workflow evolution are installable skills.
- **Target-local memory and spec**: installed projects keep facts, workstreams, memory, and specs inside the target repository, not in the plugin package.
- **Evidence-first closure**: “done” requires command output, static checks, browser evidence, or an explicit blocker.

## Install

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

## Quick Check

```text
/agent
/skills list
```

Expected package shape:

```text
best-copilot
├── plugin.json
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
| Bootstrap | `repo-init-scan`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## First Use In A Target Repository

Before the first meaningful task in a new repository, let Copilot learn the project:

```text
/init
```

or:

```bash
copilot init
```

Then start substantial work with **Senior Project Expert**. It should normalize useful facts into the target repository, create missing local scaffolds, and verify those files before substantive planning or implementation.

Target-local state belongs to the target repository:

```text
.github/instructions/project.instructions.md
.github/instructions/must.instructions.md
.github/instructions/skills-index.instructions.md
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

## Verify This Package

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
git diff --check
```

## Evolution Rules

`best-copilot` does not let agents rewrite themselves freely. Workflow changes should come from verified signals: failed commands, repeated review findings, user corrections, stale routing, or concrete installation/runtime drift.

Accepted improvements should be small, reversible, and written to the owning surface: root `agents/`, root `skills/`, `.github/instructions/**`, or target-local `memories/repo/**` and `spec/**`.

## Acknowledgements

`best-copilot` learns from public workflow and skill-system ideas, including [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent), [Superpowers](https://github.com/obra/superpowers), [gstack](https://github.com/garrytan/gstack), [spec-kit](https://github.com/github/spec-kit), [Open Design](https://github.com/nexu-io/open-design), [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill), [claude-mem](https://github.com/thedotmack/claude-mem), [fetch-skill](https://github.com/aresbit/fetch-skill/), [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills), and [Evolver](https://github.com/EvoMap/evolver). The implementation here is a Copilot CLI plugin layout with its own agents, skills, routing rules, and verification gates.
