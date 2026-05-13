---
mode: ask
description: Review the current change for correctness, regressions, verification gaps, and merge readiness.
---

# Review Prompt

Review the current change against merge-ready standards. Prioritize real risks over explanation.

## Review Order

1. Identify the change scope and intended outcome.
2. Check whether it satisfies the user request, spec, README, and instruction constraints.
3. Look for behavior regressions, boundary failures, error-handling gaps, permission/data leaks, dependency risk, and release-surface risk.
4. Check whether tests or static verification are sufficient.
5. For frontend changes, also check:
   - whether the implementation follows the repository's UI library, tokens, routing, and state patterns
   - whether Ant Design-based apps use Ant primitives, data-entry/data-display patterns, feedback, and layout conventions before custom controls
   - whether the design-system packet or visual direction is explicit enough to avoid generic AI-looking UI
   - loading, empty, error, disabled, success, and partial states
   - desktop/mobile screenshots or equivalent browser evidence, including console/network checks
   - accessibility-critical labels, focus path, text overflow, and keyboard-reachable primary actions
6. For `.github/**`, `plugin.json`, `AGENTS.md`, `memories/repo/**`, or `spec/**` customization changes, also check:
   - manifest/frontmatter/schema parseability
   - skill/agent trigger clarity and conflicts
   - references to missing skills, agents, commands, or tools
   - whether secret, PII, web fetch, execute permission, or memory write boundaries were weakened
   - stale project-specific names, internal paths, or old-template residue

## Output

List findings first, ordered by severity. If there are no blocking issues, say so clearly.

```markdown
## Findings
- [severity] file:line - finding

## Open Questions
- ...

## Verification Gaps
- ...
```
