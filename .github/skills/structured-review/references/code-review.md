# Post-Implementation Code Review

## Phase 1: spec compliance gate

Run this phase first. Review from the angle: `what is missing or extra relative to the requirement?`

Checklist:

- Read changed files and diff before deciding whether broader search is needed.
- Check whether every requirement is implemented completely.
- Check whether the patch adds behavior outside the requirement (`over-building`, YAGNI violation).
- Check explicit non-goals, forbidden behavior, and must-not-do constraints.
- Check for under-building: missing scenarios or states.
- Check whether the implementation solves the user's real intent, not only the literal text.
- Prioritize `user_provided_paths`, `priority_files`, attachments, and currently edited files over repository-wide rediscovery.
- Block on unfinished placeholders: `TBD`, `TODO`, `待实现`, template skeletons, dummy implementations.
- Check boundary cases: null, empty, extreme values, concurrency, re-entry, duplicate submission.
- Check that key branches, loops, and returns map to confirmed requirements.

If phase 1 fails, stop the review and ask for a fix. Do not proceed to phase 2 except to mention clearly scoped evidence gaps.

## Phase 2: code quality review

Run only after phase 1 passes or when the user explicitly asks for general code quality despite spec gaps.

### Correctness

Look for:

- faulty condition branches, off-by-one errors, inverted checks, stale state, race conditions
- null, empty collection, long string, negative number, timeout, retry, idempotency, and dependency failure gaps
- swallowed exceptions, silent failures, unchecked return codes, misleading success states

### Security

Look for:

- SQL injection, XSS, SSRF, path traversal, unsafe deserialization
- horizontal or vertical authorization bypass
- sensitive data leaks in logs, responses, exception messages, DOM, static config, visible text
- frontend public/login/unauthenticated pages exposing JWT, Bearer, Authorization, token, `/auth/login`, internal API paths, or internal hosts
- authentication and authorization logic flaws

### Performance and resources

Look for:

- N+1 queries, repeated uniqueness lookups, unnecessary loops, large memory allocations
- blocking work on hot paths
- unclosed streams, buffers, connections, files, or browser/page contexts
- duplicated orchestration that could reuse already validated context

### Maintainability

Look for:

- unclear names, misleading comments, incomplete Chinese comments where project conventions require them
- duplicated code where nearby implementation can be reused
- unnecessary abstractions, interfaces, configuration, indirection, or prebuilt extension points
- finite stable business values scattered as string literals instead of enums/constants
- violations of known project structural rules such as Java structure constraints in higher-level instructions
- follow-up/re-review scope creep beyond current fix and blast radius

### TDD and tests

When business logic changes, verify:

- there are tests matching the new behavior
- tests cover happy path, null/empty, invalid input, dependency errors, and relevant boundaries
- if RED/GREEN evidence is provided, the test failed before implementation and passed after implementation
- claimed coverage matches actual test names, assertions, and output

Do not accept `理论上已覆盖` as evidence.

### Developer experience

Apply when the change affects workflows, scaffolding, agents, skills, generated outputs, or developer-facing customization:

- time-to-hello-world should not become unnecessarily heavier
- error messages must explain what failed, why, and how to fix it
- names and entrypoints should be guessable
- upgrade path and linked files should be explicit
- output budget should preserve high-signal summaries, failure points, exit code, first exception, and raw recovery pointers
- token-saving claims must preserve recovery fields such as `parse_tier`, `output_savings_note`, raw failure signal, and relevant artifacts
- document/PDF/browser/audit tasks should route by document intent instead of defaulting to generic markdown

## Output template

```markdown
## findings
- [Critical|Important|Minor][confidence=NN][origin=...] file:line | issue | impact | evidence | fix

## concerns / risks / 未验证项
- ...

## required section results
- spec compliance: passed/failed/partial, evidence
- correctness: ...
- security: ...
- performance/resources: ...
- maintainability: ...
- tests/tdd: ...
- developer experience: ...

## summary
- merge recommendation: approve / request changes / needs context
- highest risk:

## next verification
- exact command or manual check, if known
```

If no blocking issue is found, explicitly write `未发现阻塞问题` and list remaining risk or evidence gaps.
