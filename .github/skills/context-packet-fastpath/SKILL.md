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
- `memory_refs`
- `spec_refs`
- `handoff_reason`

## Rules

- Lean packet: enough for one small task.
- Full packet: needed only for cross-module or high-risk work.
- Do not include whole logs, whole specs, or unrelated memory.
- If a delegate needs new files, return to PM to widen scope.
