---
name: context-packet-fastpath
description: "Use to prepare a minimal context packet for a delegated subtask or to consume a frozen packet without re-reading unrelated files."
---

# Context Packet Fastpath

## Packet Fields

- `goal`
- `scope`
- `non_goals`
- `files_involved`
- `already_read_files`
- `constraints`
- `acceptance_checks`
- `verification_budget`
- `work_mode`: `micro | standard | full`
- `context_budget`: max files or shards to open before returning for scope widening
- `stop_conditions`: when to stop searching, coding, or reviewing
- `ready_artifacts`: files, commands, screenshots, review outputs, or status records already produced
- `memory_refs`
- `spec_refs`
- `handoff_reason`

## Rules

- Lean packet: enough for one small task.
- Full packet: needed only for cross-module or high-risk work.
- Prefer `micro` or `standard` packets when the file set and acceptance checks are already clear.
- Do not include whole logs, whole specs, or unrelated memory.
- If a delegate needs new files, return to PM to widen scope.
- A delegate should consume `ready_artifacts` before reopening search.
- A delegate should stop at `context_budget` and return `NEEDS_CONTEXT` instead of broad-scanning.
- A PM-delegated specialist should return `NEEDS_USER_INPUT` to PM when human input or approval is required; it must not ask the user directly.
