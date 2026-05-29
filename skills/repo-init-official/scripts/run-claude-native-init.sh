#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"

if [ ! -d "$target_dir" ]; then
  echo "status=invalid_target_dir"
  echo "target_dir=$target_dir"
  exit 64
fi

if [ "${BEST_COPILOT_CLAUDE_NATIVE_INIT_RUNNING:-}" = "1" ]; then
  echo "status=recursive_guard"
  exit 75
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "status=claude_cli_missing"
  exit 69
fi

cd "$target_dir" || exit 64

export BEST_COPILOT_CLAUDE_NATIVE_INIT_RUNNING=1

output_file="$(mktemp "${TMPDIR:-/tmp}/best-copilot-claude-init.XXXXXX")"

claude --bare --permission-mode acceptEdits -p "/init" >"$output_file" 2>&1
status=$?

head -c 6000 "$output_file"
rm -f "$output_file"

if [ "$status" -ne 0 ]; then
  echo
  echo "status=claude_init_failed"
  echo "exit_code=$status"
  exit "$status"
fi

if [ -f "CLAUDE.md" ]; then
  echo
  echo "status=success"
  echo "artifact=CLAUDE.md"
  exit 0
fi

echo
echo "status=no_write"
echo "missing=CLAUDE.md"
exit 70
