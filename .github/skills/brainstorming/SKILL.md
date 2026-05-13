---
name: brainstorming
description: "Use when a MEDIUM/LARGE task has unclear intent, multiple viable technical routes, or a high-impact decision that must be locked before writing specs or code. DO NOT USE FOR: clear small tasks, already-confirmed specs, or routine implementation."
---

# Brainstorming

Use this skill to freeze direction before planning.

## Steps

1. Parse:
   - Literal request.
   - Real intent.
   - Success criteria.
2. Identify only decisions that change implementation path, API behavior, data model, security boundary, UX direction, or delivery scope.
3. If there is one reasonable interpretation, record it and continue.
4. If there are multiple routes, ask one focused question with 2-3 options and a recommendation.
5. After resolution, produce a Design Direction Summary:

```markdown
## Design Direction Summary
- chosen_direction:
- decision_provenance: user_confirmed|single_reasonable_interpretation
- non_goals:
- constraints:
- blast_radius:
- open_questions:
```

## Rules

- Do not ask broad open-ended questions.
- Do not enter implementation with unresolved direction.
- Do not use agent vote fallback for business, security, production, public contract, credential, or destructive decisions.
