<!-- CODEGRAPH_GITNEXUS_START -->
## Code Intelligence (codebase-memory-mcp / GitNexus / CodeGraph)

This project supports structural code intelligence through whichever MCP tools are actually exposed in the current Claude Code session. A locally installed binary is not enough: prefer `codebase-memory-mcp` only when its `mcp__codebase-memory-mcp__*` tools are visible; otherwise fall back in order.

**Priority**: `mcp__codebase-memory-mcp__*` → `mcp__gitnexus__*` → `mcp__codegraph__*` → built-in Read/Grep/Glob + shell `rg`

### Availability check

- codebase-memory-mcp: `mcp__codebase-memory-mcp__*` tools present → use `get_graph_schema`, `search_graph`, `trace_path`, `detect_changes`, `get_code_snippet`, `get_architecture`, etc.
- GitNexus: `mcp__gitnexus__*` tools present → use `gitnexus_query`, `gitnexus_context`, `gitnexus_impact`, etc.
- CodeGraph: `mcp__codegraph__*` tools present → use `codegraph_search`, `codegraph_context`, `codegraph_impact`, etc.
- None: fall back to built-in Read/Grep/Glob plus shell `rg`. Do not block.

### When to prefer code intelligence over native search

Use code intelligence for **structural** questions — what calls what, what would break, where is X defined, what is X's signature. Use native grep/read only for **literal text** queries (string contents, comments, log messages) or after you already have a specific file open.

| Question | codebase-memory-mcp Tool | GitNexus Tool | CodeGraph Tool |
|---|---|---|---|
| "Where is X defined?" | `search_graph` | `gitnexus_query` | `codegraph_search` |
| "What calls/does Y call?" | `trace_path` | `gitnexus_context` | `codegraph_callers` / `codegraph_callees` |
| "How does X reach Y?" | `trace_path` / `query_graph` | `gitnexus_context` / graph trace when exposed | `codegraph_trace` |
| "What would break if I changed Z?" | `detect_changes` / `trace_path` | `gitnexus_impact` | `codegraph_impact` |
| "Focused context for area" | `get_architecture` / `search_graph` | `gitnexus_context` | `codegraph_context` |
| "See several symbols' source" | `get_code_snippet` | `gitnexus_query` + `gitnexus_context` | `codegraph_explore` |
| "Check what changed" | `detect_changes` | `gitnexus_detect_changes` | — |
| "Is the index healthy?" | `index_status` / `get_graph_schema` | `npx gitnexus status` | `codegraph_status` |

### Rules of thumb

- **Answer directly — don't delegate exploration.** Use 2-3 code intelligence calls max. The index IS the pre-built search layer — spawning a file-reading sub-agent repeats work it already did.
- **Trust structural results.** They come from AST + graph analysis. Do NOT re-verify with grep.
- **Don't grep first** when looking up a symbol by name. `search_graph`, `gitnexus_query`, or `codegraph_search` is faster.
- **Index lag**: file watchers may debounce behind writes; don't re-query immediately after editing a file in the same turn.

### If index doesn't exist

- codebase-memory-mcp: run `codebase-memory-mcp config set auto_index true` once, or ask the exposed MCP tools to index the current project when available.
- GitNexus: run `npx gitnexus analyze` to build the index.
- CodeGraph: run `codegraph init -i` to build the index.
<!-- CODEGRAPH_GITNEXUS_END -->
