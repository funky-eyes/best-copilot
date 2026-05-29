#!/bin/sh
set -eu

INPUT=$(cat)
SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)

if command -v python3 >/dev/null 2>&1; then
  printf '%s' "$INPUT" | python3 "$SCRIPT_DIR/best-copilot-init-gate.py"
  exit $?
fi

if printf '%s' "$INPUT" | grep -q '"hook_event_name"[[:space:]]*:[[:space:]]*"UserPromptSubmit"'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"best-copilot init gate could not run full checker because python3 is unavailable. Treat provider compatibility as unverified and run INIT_GATE -> INIT_SCAN before any business-source tool use."}}'
  exit 0
fi

if printf '%s' "$INPUT" | grep -q '"hook_event_name"[[:space:]]*:[[:space:]]*"UserPromptExpansion"'; then
  if printf '%s' "$INPUT" | grep -Eq '"command_name"[[:space:]]*:[[:space:]]*"best-copilot:(repo-init|target-instructions-bootstrap|target-memory-bootstrap|target-spec-bootstrap|senior-project-expert)'; then
    printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptExpansion","additionalContext":"best-copilot init gate could not run full checker because python3 is unavailable. Continue only with repo init before business-source tool use."}}'
  elif printf '%s' "$INPUT" | grep -q '"command_name"[[:space:]]*:[[:space:]]*"best-copilot:'; then
    printf '%s\n' '{"decision":"block","reason":"best-copilot init gate blocked this slash command because python3 is unavailable and target sentinel readiness cannot be verified. Start with /best-copilot:repo-init-gate, /best-copilot:repo-init-scan, or senior-project-expert."}'
  fi
  exit 0
fi

if printf '%s' "$INPUT" | grep -q '"hook_event_name"[[:space:]]*:[[:space:]]*"PreToolUse"'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"best-copilot init gate blocked this tool because python3 is unavailable, so sentinel readiness cannot be verified. Install python3 or run with a provider/runtime where the hook checker can execute."}}'
  exit 0
fi

exit 0