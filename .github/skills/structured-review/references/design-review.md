# Medium/Large Feature Design Review

Use before implementation when a new requirement touches shared abstractions, external interfaces, multiple modules, frontend interaction flows, security boundaries, or more than eight files.

## Required pre-check

Before reviewing, consume these inputs if provided:

- `existing_code_leverage_map`
- `related_context_pack`
- `risk_hypotheses_seed`
- spec/design/tasks/acceptance criteria
- frontend wireframes, screenshots, or page states when UI is involved

If these are missing and the design depends on them, return `NEEDS_CONTEXT` or clearly mark the evidence gap. Do not rubber-stamp a spec that lacks necessary context.

## Review posture

Every reviewer lane must first attempt at least one counterexample or rebuttal. Assume failure may occur due to lost context, over-broad reuse, duplicate orchestration, duplicate uniqueness queries, wrong transaction boundaries, hidden external side effects, missing frontend states, or permission leaks.

If no issue is found, still state at least one risk hypothesis that was tested and rejected with evidence.

## Lanes

Run the relevant lanes independently. Default lanes:

- technical architect
- developer engineer
- QA
- security
- frontend design expert only when page/UI/interaction/responsive behavior is in scope

### Technical architect lane

Must include:

- at least one aggressive hypothesis and verification/rebuttal
- at least one concern, even low severity, marked `source=self-review`
- implementation hidden-trap analysis
- at least one `counterexample_or_rebuttal`

Check:

- technical feasibility and blind spots
- estimated changed file count greater than 8 or new shared abstraction count greater than 2
- simpler equivalent design alternatives
- concurrency, transaction boundaries, lifecycle constraints
- reuse of already known context, validated objects, and business semantics instead of re-querying/re-orchestrating downstream
- module dependencies, cycles, and missing prerequisites
- parallelization feasibility by file/module boundary
- for agents/skills/instructions: discovery surface, context budget, tool availability, conflict rules, and verification loop

### QA lane

Must include:

- one likely missing-spec risk
- one scenario most likely to fail if requirement understanding is wrong
- one `counterexample_or_rebuttal`

Check:

- every requirement is traceable and unambiguous
- current-chain context, validated objects, and existing owner behavior are written into design assumptions
- null/empty/extreme/error/concurrency/re-entry boundaries
- acceptance criteria directly support test case writing
- each task has precise verification commands without placeholders
- commands can run independently without undefined environment variables or manual-only steps
- non-automatable scenarios are marked as risk
- happy path and error path are defined
- frontend loading/empty/error/success/partial states are defined when frontend is involved
- customization specs define frontmatter validation, trigger validation, conflict detection, and minimal verification

### Developer engineer lane

Must include:

- one realistic implementation trap: `if I implement this tomorrow, where will this spec mislead me?`
- one `counterexample_or_rebuttal`

Check:

- task breakdown is directly implementable and not hiding prerequisites
- owner/context/business semantics/reuse points are explicit
- likely traps such as copied compatibility entrypoints, outer duplicate catch + reread, lock path plus repeated uniqueness check, wide query reuse, repeated orchestration, or unnecessary logic
- task granularity and verification support fast iteration
- over-building signals likely to be introduced by implementers

### Frontend design expert lane

Enable only for page, UI, interaction, responsive, form, component, visual, or frontend feature scope.

Must include:

- one likely UX failure if the spec is implemented as written
- one `counterexample_or_rebuttal`

Check:

- loading, empty, error, success, partial, disabled, hover, active, focus, and validation states
- reuse of existing component system and layout primitives
- form validation, interaction copy, visible text, responsive breakpoints, and localization length risk
- accessibility: keyboard flow, focus management, labels, semantic roles, contrast, error announcement
- frontend reviewer stays within frontend scope when frontend is only part of the task

### Security lane

Must include:

- likely attack path
- whether defenses exist or remain unverified

Check:

- new external interfaces have authentication and authorization design
- credentials, PII, tokens, and sensitive data flows are protected
- new dependencies have CVE review when web access is allowed; if no new dependency exists, state `无新依赖，跳过`
- logs and errors do not expose sensitive assets
- authentication/authorization changes require security verification
- agents/skills/instructions do not loosen tool permissions, external fetch scope, or sensitive output paths

## Status routing

Use exactly these lane statuses:

- `DONE`: no blocking concern
- `DONE_WITH_CONCERNS`: concern exists; include severity `low|medium|high`
- `NEEDS_CONTEXT`: missing evidence prevents reliable review
- `BLOCKED`: unexpected block; route as `NEEDS_CONTEXT`

Routing:

- all lanes `DONE`: proceed to implementation
- any `DONE_WITH_CONCERNS` with `low` or `medium`: record risk and may proceed
- any `DONE_WITH_CONCERNS` with `high`: revise spec before implementation
- any `NEEDS_CONTEXT` or `BLOCKED`: fill context and re-review before implementation

## Output template

```markdown
## design_review_findings
- [Critical|Important|Minor][confidence=NN][origin=...] file/spec-section | issue | impact | evidence | fix

## lane_results
### technical architect
- status:
- concerns:
- counterexample_or_rebuttal:

### developer engineer
- status:
- concerns:
- counterexample_or_rebuttal:

### QA
- status:
- concerns:
- counterexample_or_rebuttal:

### security
- status:
- concerns:
- attack_path:
- defense_or_gap:

### frontend design expert
- status:
- concerns:
- counterexample_or_rebuttal:

## routing_decision
- decision: proceed / revise spec / needs context
- reason:
- required spec changes:
```
