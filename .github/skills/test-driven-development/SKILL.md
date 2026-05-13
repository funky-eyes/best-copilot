---
name: test-driven-development
description: "Use when adding behavior or fixing a bug where a focused failing test can be written first."
---

# Test Driven Development

## Cycle

1. RED: add a focused failing test or reproducible check.
2. GREEN: implement the smallest change to pass.
3. REFACTOR: clean only what the passing test justifies.

## Test Selection

- Cover normal path, boundary path, and relevant error path.
- Prefer existing test framework and fixtures.
- Avoid brittle timing, network, and environment assumptions.
- If a test cannot be added, explain why and provide alternate verification.
- For new or changed skills, include 2-3 realistic trigger/eval prompts and expected outcomes before claiming the skill is improved.

## Output

Report the failing test/check, implementation change, passing evidence, and remaining gaps.
