---
id: global
type: always-on-memory
updated_at: 2026-05-11
status: template
tags: [global, rules, preferences]
---

# Global Memory

## Stable Rules

- Prefer repo truth over prior memory, chat history, or external examples.
- Keep answers concise and evidence-first.
- Use indexed memory retrieval before opening long memory or spec files.

## Do Not Store

- Secrets, credentials, tokens, private keys, PII, raw logs, or sensitive internal URLs.
- Temporary frustration, one-off chat remarks, or unverified guesses.

## Update Policy

- Add only stable, reusable information.
- Mark deprecated decisions instead of silently overwriting them.
- Keep this file short; move project-specific details to `memories/repo/`.
