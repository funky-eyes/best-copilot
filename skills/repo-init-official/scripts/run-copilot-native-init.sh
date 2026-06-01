#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"

if [ ! -d "$target_dir" ]; then
  echo "status=invalid_target_dir"
  echo "target_dir=$target_dir"
  exit 64
fi

if ! command -v copilot >/dev/null 2>&1; then
  echo "attempted=copilot_init"
  echo "native_command=copilot init"
  echo "status=copilot_cli_missing"
  exit 69
fi

cd "$target_dir" || exit 64

echo "attempted=copilot_init"
echo "native_command=copilot init"
echo "runner=copilot init"

output_file="$(mktemp "${TMPDIR:-/tmp}/best-copilot-copilot-init.XXXXXX")"
timeout_seconds="${BEST_COPILOT_NATIVE_INIT_TIMEOUT_SECONDS:-45}"

case "$timeout_seconds" in
  ''|*[!0-9]*) timeout_seconds=45 ;;
esac

if command -v perl >/dev/null 2>&1; then
  perl -e 'use POSIX ":sys_wait_h"; $timeout = shift @ARGV; $pid = fork(); die "fork failed: $!\n" unless defined $pid; if ($pid == 0) { exec @ARGV; die "exec failed: $!\n"; } $deadline = time + $timeout; while (1) { $done = waitpid($pid, WNOHANG); if ($done == $pid) { exit($? >> 8); } if (time >= $deadline) { kill "TERM", $pid; select undef, undef, undef, 0.2; kill "KILL", $pid; exit 124; } select undef, undef, undef, 0.1; }' "$timeout_seconds" copilot init >"$output_file" 2>&1
else
  copilot init >"$output_file" 2>&1
fi
status=$?

head -c 6000 "$output_file"

if grep -Fq "No authentication information found" "$output_file"; then
  rm -f "$output_file"
  echo
  echo "status=copilot_auth_missing"
  exit 69
fi

rm -f "$output_file"

if [ "$status" -eq 124 ] || [ "$status" -eq 142 ]; then
  echo
  echo "status=copilot_init_timeout"
  echo "timeout_seconds=$timeout_seconds"
  exit 70
fi

if [ "$status" -ne 0 ]; then
  echo
  echo "status=copilot_init_failed"
  echo "exit_code=$status"
  exit "$status"
fi

if [ -f ".github/instructions/project.instructions.md" ] || [ -f "AGENTS.md" ] || [ -f "CLAUDE.md" ]; then
  echo
  echo "status=success"
  if [ -f ".github/instructions/project.instructions.md" ]; then
    echo "artifact=.github/instructions/project.instructions.md"
  elif [ -f "AGENTS.md" ]; then
    echo "artifact=AGENTS.md"
  else
    echo "artifact=CLAUDE.md"
  fi
  exit 0
fi

echo
echo "status=no_write"
echo "missing=.github/instructions/project.instructions.md"
exit 70
