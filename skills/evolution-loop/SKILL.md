---
name: evolution-loop
description: "Use after meaningful task closeout, repeated failure, review loops, stale triggers, or user feedback that an agent/skill/workflow should improve. Turns verified signals into auditable, bounded evolution proposals for agents, skills, memory, and README guidance. DO NOT USE FOR: speculative prompt tweaks without evidence, direct autonomous rewrites, or changing user-facing behavior without PM review."
---

# Evolution Loop

This skill gives `best-copilot` a lightweight, auditable evolution cycle inspired by Evolver and Memento-style reflective learning.

## Core Principle

Evolution is not free-form rewriting. It is a bounded loop:

1. **Read** verified signals from task results, review findings, failed commands, user corrections, memory, and spec drift.
2. **Select** the smallest reusable improvement target: agent, skill, instruction, memory rule, README guidance, or spec template.
3. **Propose** a protocol-bound mutation with evidence, scope, rollback, and validation.
4. **Validate** with static checks, eval prompts, review, or command evidence.
5. **Write** only accepted learnings back to the canonical root `agents/`, root `skills/`, `.github/instructions/**`, `memories/repo/**`, or `spec/**` owner in the target repository.

## EvolutionEvent

Record each accepted evolution as a compact event:

```markdown
## EvolutionEvent: <YYYY-MM-DD-topic>
- signal:
- target:
- mutation:
- validation:
- rollback:
- status: proposed|accepted|rejected|deprecated
```

## Strategy Presets

- `repair-only`: fix broken trigger, broken route, false claim, failed validation.
- `harden`: reduce ambiguity, add guardrails, improve verification, prevent repeated errors.
- `balanced`: small improvement that preserves current workflow.
- `innovate`: add a new capability only when existing skills cannot cover repeated demand.

## Guardrails

- Do not copy external prompts or code wholesale; extract local primitives only.
- Do not evolve from a single weak signal unless the failure is severe and reproducible.
- For skill changes, prefer trigger-focused descriptions that say when to load the skill, not a process summary that lets agents shortcut the skill body.
- Keep frequently referenced skills short; move heavy references, examples, or tool details into separate files or existing focused skills.
- Do not write secrets, PII, raw logs, or private URLs into memory.
- Do not change tool permissions, safety boundaries, public contracts, or install surfaces without explicit review.
- Do not store target repository evolution or task state in the installed plugin package or plugin cache.
- Prefer deprecating or tightening old rules over adding parallel rules.

## Output

```markdown
## Evolution Proposal
- strategy:
- signals:
- target:
- proposed_mutation:
- expected_delta:
- validation_plan:
- rollback_plan:
- writeback_files:
```
