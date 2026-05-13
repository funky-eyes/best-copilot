# best-copilot

English | [Simplified Chinese](README.zh-CN.md) | [Korean](README.ko.md) | [Japanese](README.ja.md)

`best-copilot` is an installable, reusable, and continuously improvable AI agent team template. It is designed first as a GitHub Copilot CLI plugin, keeps `.github/**` as the canonical Copilot customization source, and lets Codex reuse the same team contract through `AGENTS.md` and `.codex/**`.

The core idea is simple: substantial engineering work should start with the **Senior Project Expert**, then move through architecture, specification, implementation, frontend, QA, security, fix, and evolution stages as needed.

## Installation

Register this repository as a Copilot CLI plugin marketplace:

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

Install the plugin from the registered marketplace:

```bash
copilot plugin install best-copilot@best-copilot
```

Direct installs from repositories, URLs, or local paths are deprecated in Copilot CLI. Use the marketplace flow above for normal installs. For local development, register the local checkout as a marketplace instead:

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

Check the installation:

```text
/agent
/skills list
```

When installed inside a target repository, Copilot reads `.github/agents`, `.github/skills`, `.github/instructions`, and `.github/copilot-instructions.md`. Codex reads `AGENTS.md` and follows `.codex/instructions`, `.codex/prompts`, and `.codex/skills` symlinks back to `.github`.

## First Use

Before the first meaningful task in a new repository, let Copilot learn the repository:

```text
/init
```

or run:

```bash
copilot init
```

`/init` is Copilot CLI's official initialization flow. It scans the repository and writes or updates `.github/copilot-instructions.md`. The `repo-init-scan` skill treats this as a first-use gate: if repository facts are still placeholders, initialize first and only then start real work.

Recommended first facts:

- `.github/copilot-instructions.md`: project type, build/test/dev commands, entrypoints, test framework, and security/API/UI/schema owners.
- `memories/repo/project-state.md`: current project state and durable constraints.
- `memories/repo/current-workstreams.md`: current focus, next resume action, and last verified fact.
- `spec/INDEX.md`: active spec routing.

## Language Policy

Every agent must first identify the user's primary language. Mixed inputs are common: a user may describe the problem in one language and paste stack traces, logs, code, or API responses in another. The primary language is the language used for the actual request or explanation, not the incidental language inside pasted evidence.

Responses should use the detected primary language unless the user explicitly asks for another language.

## Team Entry

Large tasks should start with the **Senior Project Expert**. This role does not write production code directly. It owns coordination:

- Understand the user's intent and success criteria.
- Decide whether `/init`, spec, planning, design review, or parallel work is needed.
- Freeze scope, non-goals, acceptance checks, and verification budget.
- Route work to the right specialist and synthesize fan-out/fan-in results.
- Close the task by updating spec, memory, verification evidence, and the next resume point.

Small tasks can be handled directly by the default assistant or a specialist. If a task crosses modules, changes public contracts, touches permissions/dependencies/release surfaces, or asks for deep analysis, use the Senior Project Expert first.

## Agent Roles

| Agent | Owns | Does Not Own |
| --- | --- | --- |
| Senior Project Expert | Intent, scope, orchestration, parallel dispatch, fan-in decisions, closeout, evolution signals | Direct production implementation |
| Specification Writer | Discovery evidence, requirements/design/tasks, ADRs, progress records, memory/spec recovery | Production implementation |
| Technical Architect | Backend/full-stack design and main implementation, API/data/service boundaries, architecture review | Frontend polish, scoped parallel slices |
| Developer | Frozen implementation slices, focused tests, minimal verification | Architecture changes or scope expansion |
| Frontend Designer | Pages, components, interaction, responsiveness, browser behavior, visual verification | Backend mainline work |
| Quality Assurance Expert | Functional verification, regression risk, code review, merge readiness | Security review and fixes |
| Security Reviewer | Auth boundaries, sensitive data flow, dependency risk, release-surface security | General functional QA |
| Root Cause Fixer | Failure analysis, minimal patches, regression verification | Speculation-driven refactors |

## Model Strategy

The roles are not just renamed copies of one generic agent. Each agent declares an explicit model in its `.github/agents/*.agent.md` frontmatter, and the model choice matches the kind of reasoning the role needs:

| Agent | Model | Reasoning Profile |
| --- | --- | --- |
| Senior Project Expert | GPT-5.4 | Long-horizon coordination, scope control, fan-out/fan-in decisions, and closeout judgment |
| Technical Architect | GPT-5.4 | Deep backend/full-stack reasoning, public contract design, data/API boundary analysis, and mainline implementation strategy |
| Specification Writer | Gemini 3.1 Pro (Preview) | Broad-context synthesis, structured requirements/design/tasks, ADRs, and recovery records |
| Developer | Gemini 3.1 Pro (Preview) | Focused execution of frozen slices, fast code-context alignment, tests, and bounded verification |
| Frontend Designer | Gemini 3.1 Pro (Preview) | UI/state/context synthesis, Ant Design-style enterprise patterns, active design-system reasoning, responsive behavior, interaction quality, and browser evidence planning |
| Quality Assurance Expert | Claude Sonnet 4.6 | Low-noise review, regression reasoning, test sufficiency judgment, and merge-readiness calls |
| Security Reviewer | Gemini 3.1 Pro (Preview) | Release-surface analysis, permission boundaries, sensitive-data flow, dependency and configuration review |
| Root Cause Fixer | Claude Sonnet 4.6 | Failure triage, hypothesis pruning, minimal patch selection, and regression proof |

The routing policy is part of the product: orchestration and architecture use higher-depth planning models, implementation and specification use broad-context execution models, and QA/fix roles use concise review/debug models to keep findings actionable.

## Large Task Flow

1. **Init**: Run `/init` or `copilot init` if repository facts are missing.
2. **Discover**: The Senior Project Expert reads minimal context and freezes target, scope, risks, and acceptance checks.
3. **Plan**: The Specification Writer updates spec; `writing-plans` turns it into executable slices.
4. **Design Review**: Architecture, QA, Security, and Frontend review the spec when their surface is affected.
5. **Implement**: Technical Architect owns the mainline; Developer handles non-overlapping slices; Frontend Designer handles UI.
6. **Verify**: QA runs minimal sufficient verification; frontend work gets browser evidence; failures enter the fix loop.
7. **Secure**: Security reviews release-surface, dependency, auth, and sensitive-data risks when present.
8. **Fix Loop**: Root Cause Fixer handles confirmed failures and sends them back to verification.
9. **Close**: Senior Project Expert summarizes changes, evidence, risks, and next resume point.
10. **Evolve**: Repeated failures, stale triggers, review loops, or reusable lessons become auditable EvolutionEvents.

## Self-Evolution

`best-copilot` does not let agents rewrite themselves freely. Evolution is evidence-bound and reversible.

Evolution loop:

1. **Read**: task results, failed commands, review findings, user corrections, memory, and spec drift.
2. **Select**: the smallest improvement target: agent, skill, instruction, prompt, memory, README, or spec template.
3. **Propose**: an Evolution Proposal with evidence, scope, validation, and rollback.
4. **Validate**: frontmatter/schema checks, trigger evals, static checks, review, or command evidence.
5. **Write**: only accepted learning goes back to `.github/**`, `memories/repo/**`, or `spec/**`.

Accepted improvements are recorded as `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status`.

## Project Structure

```text
.
├── plugin.json
├── AGENTS.md
├── .github/
│   ├── agents/
│   ├── instructions/
│   ├── prompts/
│   └── skills/
├── .codex/
│   ├── agents/
│   ├── config.toml
│   ├── instructions -> ../.github/instructions
│   ├── prompts -> ../.github/prompts
│   └── skills -> ../.github/skills
├── memories/
│   ├── global.md
│   ├── user-profile.md
│   └── repo/
└── spec/
    ├── INDEX.md
    └── templates/
```

## Strengths

- **Copilot-first and installable**: `.github/plugin/marketplace.json` publishes the marketplace entry, and root `plugin.json` declares agents and skills for Copilot CLI.
- **Codex-compatible**: `AGENTS.md` and `.codex` adapters reuse the same `.github` source of truth.
- **Init before execution**: official `/init` reduces blind guessing in new repositories.
- **Senior PM orchestration**: large work is scoped, reviewed, verified, and closed in phases.
- **RAG-lite memory**: Markdown index plus current workstream restore context without loading all history.
- **Spec-memory alignment**: spec owns requirements and acceptance; memory owns recovery and verified facts.
- **Lean default skills**: the default install keeps high-frequency engineering skills only.
- **Evidence-first verification**: every completion claim needs command, static check, browser evidence, or an explicit verification blocker.
- **Auditable evolution**: proven workflow lessons become reversible EvolutionEvents.

## Acknowledgements

`best-copilot` is inspired by and learns from the public ideas, workflow structures, and skill design patterns in these projects:

- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent): multi-agent orchestration, deep init, planning-first workflows, and session recovery.
- [Superpowers](https://github.com/obra/superpowers): composable software engineering skills such as TDD, systematic debugging, planning, review, and verification.
- [gstack](https://github.com/garrytan/gstack): Think -> Plan -> Build -> Review -> Test -> Ship -> Reflect delivery discipline.
- [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill): design-system packets and UI/UX guardrails.
- [Open Design](https://github.com/nexu-io/open-design): local-first design workflow ideas, active design systems, artifact preview, and craft-review discipline.
- [claude-mem](https://github.com/thedotmack/claude-mem): lightweight memory and cross-session recovery ideas.
- [fetch-skill](https://github.com/aresbit/fetch-skill/): source-aware fetching, output modes, and fallback fetch ladders.
- [Anthropic skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator): skill frontmatter, progressive disclosure, eval prompts, and trigger optimization.
- [Anthropic code-simplifier](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier): behavior-preserving simplification of recently changed code.
- [Anthropic code-review](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review): multi-perspective review and confidence filtering.
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills): Read -> Execute -> Reflect -> Write learning loops.
- [Evolver](https://github.com/EvoMap/evolver): protocolized evolution, Genes/Capsules/Events, strategy presets, and auditable evolution records.
