<!-- CODEGRAPH_GITNEXUS_START -->
## Code Intelligence (GitNexus / CodeGraph)

This project supports structural code intelligence via GitNexus (preferred) or CodeGraph. Use whichever MCP tools are available in the current session.

**Priority**: `mcp__gitnexus__*` → `mcp__codegraph__*` → built-in Read/Grep/Glob + shell `rg`

### Availability check

- GitNexus: `mcp__gitnexus__*` tools present → use `gitnexus_query`, `gitnexus_context`, `gitnexus_impact`, etc.
- CodeGraph: `mcp__codegraph__*` tools present → use `codegraph_search`, `codegraph_context`, `codegraph_impact`, etc.
- Neither: fall back to built-in Read/Grep/Glob plus shell `rg`. Do not block.

### When to prefer code intelligence over native search

Use code intelligence for **structural** questions — what calls what, what would break, where is X defined, what is X's signature. Use native grep/read only for **literal text** queries (string contents, comments, log messages) or after you already have a specific file open.

| Question | GitNexus Tool | CodeGraph Tool |
|---|---|---|
| "Where is X defined?" | `gitnexus_query` | `codegraph_search` |
| "What calls/does Y call?" | `gitnexus_context` | `codegraph_callers` / `codegraph_callees` |
| "How does X reach Y?" | `gitnexus_context` / graph trace when exposed | `codegraph_trace` |
| "What would break if I changed Z?" | `gitnexus_impact` | `codegraph_impact` |
| "Focused context for area" | `gitnexus_context` | `codegraph_context` |
| "See several symbols' source" | `gitnexus_query` + `gitnexus_context` | `codegraph_explore` |
| "Check what changed" | `gitnexus_detect_changes` | — |
| "Is the index healthy?" | `npx gitnexus status` | `codegraph_status` |

### Rules of thumb

- **Answer directly — don't delegate exploration.** Use 2-3 code intelligence calls max. The index IS the pre-built search layer — spawning a file-reading sub-agent repeats work it already did.
- **Trust structural results.** They come from AST + graph analysis. Do NOT re-verify with grep.
- **Don't grep first** when looking up a symbol by name. `gitnexus_query` / `codegraph_search` is faster.
- **Index lag**: the file watcher debounces ~500ms behind writes; don't re-query immediately after editing a file in the same turn.

### If index doesn't exist

- GitNexus: run `npx gitnexus analyze` to build the index.
- CodeGraph: run `codegraph init -i` to build the index.
<!-- CODEGRAPH_GITNEXUS_END -->
