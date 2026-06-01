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

echo "attempted=claude_native_slash_init"
echo "native_command=/init"
echo "runner=claude --bare --permission-mode acceptEdits -p /init"

output_file="$(mktemp "${TMPDIR:-/tmp}/best-copilot-claude-init.XXXXXX")"
timeout_seconds="${BEST_COPILOT_CLAUDE_NATIVE_INIT_TIMEOUT_SECONDS:-45}"

case "$timeout_seconds" in
  ''|*[!0-9]*) timeout_seconds=45 ;;
esac

if command -v perl >/dev/null 2>&1; then
  perl -e 'use POSIX ":sys_wait_h"; $timeout = shift @ARGV; $pid = fork(); die "fork failed: $!\n" unless defined $pid; if ($pid == 0) { exec @ARGV; die "exec failed: $!\n"; } $deadline = time + $timeout; while (1) { $done = waitpid($pid, WNOHANG); if ($done == $pid) { exit($? >> 8); } if (time >= $deadline) { kill "TERM", $pid; select undef, undef, undef, 0.2; kill "KILL", $pid; exit 124; } select undef, undef, undef, 0.1; }' "$timeout_seconds" claude --bare --permission-mode acceptEdits -p "/init" >"$output_file" 2>&1
else
  claude --bare --permission-mode acceptEdits -p "/init" >"$output_file" 2>&1
fi
status=$?

head -c 6000 "$output_file"
rm -f "$output_file"

if [ "$status" -eq 124 ] || [ "$status" -eq 142 ]; then
  echo
  echo "status=claude_init_timeout"
  echo "timeout_seconds=$timeout_seconds"
  exit 70
fi

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
