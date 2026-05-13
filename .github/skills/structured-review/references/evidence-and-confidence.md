# Evidence and Confidence Rules

## Reviewer stance

Review with a defect-finding mindset. Assume the change may contain bugs, spec drift, missing states, security leaks, or over-engineering until evidence shows otherwise.

Every conclusion needs evidence from at least one of:

- code line, diff hunk, screenshot, trace, log, test result, or command output
- explicit spec requirement or non-goal
- official documentation or platform behavior
- established project convention found in nearby code or higher-level instructions

Avoid unsupported language such as `应该没问题`, `理论上可以`, or `看起来没影响`.

## Origin classification

For every finding, classify origin:

- `introduced_by_change`: caused by or made worse by the current change.
- `pre_existing`: already existed and was not worsened by the current change.
- `UNVERIFIED_ORIGIN`: not enough evidence to distinguish.

Use diff, review scope, history/blame context, prior findings, or user-provided context when available. Do not block on `pre_existing` or `UNVERIFIED_ORIGIN` unless the current change directly depends on the risky behavior.

## Confidence scoring

Assign `confidence=0-100`:

- `0-49`: weak evidence, likely false positive, or speculative.
- `50-79`: plausible issue but not enough evidence to block.
- `80-100`: strong evidence, actionable, and relevant to the current change.

Default final filtering:

- final findings: `confidence >= 80`
- concerns/risks: `confidence < 80`, missing context, or uncertain origin
- never hide major unknowns; mark them as `未验证项` instead of presenting them as findings

## Severity

Use exactly these severities:

- `Critical`: correctness failure, security boundary failure, resource leak, data corruption, explicit spec noncompliance, or release-blocking missing behavior.
- `Important`: maintainability, performance hotspot, YAGNI/over-building, fragile implementation, incomplete tests for meaningful business logic, or high-value quality issue that should be fixed before merge.
- `Minor`: naming, comments, formatting, small clarity improvements, or non-blocking refactors.

Blocking rule: only `Critical` and selected high-confidence `Important` issues should block. Cap blockers at 3 unless the user asks for exhaustive output.

## Anti-noise filter

Do not promote these to final findings by default:

- lint/formatter issues that tooling will catch
- pure preference without maintainability impact
- speculative future extensibility concerns
- pre-existing issues outside current blast radius
- “could be cleaner” suggestions without concrete risk
- requests for extra abstraction, configuration, or indirection only for hypothetical future use

Prefer simpler, more direct fixes over clever abstractions.
