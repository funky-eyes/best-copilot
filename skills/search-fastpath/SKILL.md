---
name: search-fastpath
description: "Use when target files are unknown, repeated search is becoming expensive, or an agent is about to do broad repo-wide scanning. DO NOT USE FOR: explicit user paths or already frozen files_involved."
---

# Search Fastpath

## Goal

Find the right files quickly without turning every task into an unbounded repository scan.

## Search Order

1. User-provided paths, current files, attachments, changed files.
2. Repo indexes: `README*`, `.github/instructions/project.instructions.md`, and target-local `spec/INDEX.md` / `memories/repo/INDEX.md` when present.
3. File-name discovery with `rg --files` or `find`.
4. Scoped content search with `rg` in the smallest likely directory.
5. External sources only when repo evidence cannot answer the question and current instructions allow web use.

## External Fetch Ladder

When a task needs web or repository evidence, use a source-aware ladder inspired by fetch-skill:

1. Prefer primary source URLs provided by the user.
2. Prefer raw Markdown / raw source over rendered HTML when available.
3. Extract the smallest relevant section, not the whole page.
4. Keep `source_url`, `fetch_mode`, and `fallback_used` in the result.
5. Treat social posts, mirrors, marketplaces, and blog summaries as secondary hints unless the user explicitly asked for them.
6. If output is summarized or truncated, keep a recovery URL or command.

## Stop Rules

- Stop after enough evidence supports the next action.
- Stop after two searches with no new signal.
- Do not search directories excluded by PM or user.
- Do not inject long outputs; summarize and keep recovery commands.

## Output

```markdown
## Search Result
- mode:
- commands:
- candidate_files:
- selected_files:
- gaps:
```
