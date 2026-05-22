---
name: context-packet-fastpath
description: "Use to prepare a minimal context packet for a delegated subtask or to consume a frozen packet without re-reading unrelated files."
---

# Context Packet Fastpath

## Packet Fields

- `goal`
- `user_provided_paths`
- `user_intent_summary`
- `expected_outcome`
- `scope`
- `non_goals`
- `files_involved`
- `changed_files`
- `priority_files`
- `already_read_files`
- `dependencies`
- `reference_files`
- `constraints`
- `forbidden_approaches`
- `acceptance_checks`
- `verification_budget`
- `work_mode`: `micro | standard | full`
- `task_type`: `implementation | design_review | verification | fix | spec`
- `search_hints`
- `context_budget`: max files or shards to open before returning for scope widening
- `stop_conditions`: when to stop searching, coding, or reviewing
- `authoritative_repo_facts`
- `source_provenance_refs`
- `review_followup_scope`
- `previously_verified_items`
- `review_lanes`
- `ready_artifacts`: files, commands, screenshots, review outputs, or status records already produced
- `required_artifacts`
- `recommended_next_stage`
- `memory_refs`
- `spec_refs`
- `dispatch_reason`

## Rules

- Lean packet: enough for one small task.
- Full packet: needed only for cross-module or high-risk work.
- Prefer `micro` or `standard` packets when the file set and acceptance checks are already clear.
- Do not include whole logs, whole specs, or unrelated memory.
- If a delegate needs new files, return to PM to widen scope.
- A delegate must consume `task_type`, `user_intent_summary`, `review_followup_scope`, `previously_verified_items`, `ready_artifacts`, `required_artifacts`, and `recommended_next_stage` before reopening search.
- A delegate should stop at `context_budget` and return `NEEDS_CONTEXT` instead of broad-scanning.
- A delegate should treat `authoritative_repo_facts` and `source_provenance_refs` as fixed context unless the packet itself says they are provisional.
- Specialists must not ask the user directly. If PM/coordinator is present and human input or approval is required, return `NEEDS_USER_INPUT` to PM. Otherwise return `BLOCKED missing_top_level_question` with the exact question.
