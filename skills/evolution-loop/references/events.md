# Plugin Evolution Events

## EvolutionEvent: 2026-06-04-micro-self-review-gate
- signal: User reported that simple implementations can bypass Developer dispatch and close without cross-validation or even author review.
- target: `core-workflow-contract`, `senior-project-expert-workflow`, `verification-before-completion`, repository instructions, and target bootstrap templates.
- mutation: Require `implementation_self_review` for any changed files, allow micro work to skip cross-author review only when low-risk, and add final verification fallback for missing self-review.
- validation: Static schema/frontmatter checks, scoped diff review, GitNexus change detection, and three-pass customization self-review.
- rollback: Revert this event and the related self-review gate changes in the listed workflow and template files.
- status: accepted
