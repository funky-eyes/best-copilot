#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"
timeout_seconds="${BEST_COPILOT_CLAUDE_NATIVE_INIT_TIMEOUT_SECONDS:-45}"

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

case "$timeout_seconds" in
  ''|*[!0-9]*) timeout_seconds=45 ;;
esac

find_local_init_skill() {
  for rel_path in "skills/init/SKILL.md" ".claude/skills/init/SKILL.md"; do
    if [ -f "$rel_path" ]; then
      printf '%s\n' "$rel_path"
      return 0
    fi
  done
  return 1
}

run_with_timeout() {
  output_file="$1"
  shift
  if command -v perl >/dev/null 2>&1; then
    perl -e 'use POSIX ":sys_wait_h"; $timeout = shift @ARGV; $pid = fork(); die "fork failed: $!\n" unless defined $pid; if ($pid == 0) { exec @ARGV; die "exec failed: $!\n"; } $deadline = time + $timeout; while (1) { $done = waitpid($pid, WNOHANG); if ($done == $pid) { exit($? >> 8); } if (time >= $deadline) { kill "TERM", $pid; select undef, undef, undef, 0.2; kill "KILL", $pid; exit 124; } select undef, undef, undef, 0.1; }' "$timeout_seconds" "$@" >"$output_file" 2>&1
  else
    "$@" >"$output_file" 2>&1
  fi
}

emit_success_if_artifact_exists() {
  if [ -f ".github/instructions/project.instructions.md" ]; then
    echo "status=success"
    echo "artifact=.github/instructions/project.instructions.md"
    return 0
  fi
  if [ -f "CLAUDE.md" ]; then
    echo "status=success"
    echo "artifact=CLAUDE.md"
    return 0
  fi
  if [ -f "AGENTS.md" ]; then
    echo "status=success"
    echo "artifact=AGENTS.md"
    return 0
  fi
  return 1
}

run_claude_init_attempt() {
  attempt_name="$1"
  runner_label="$2"
  native_command_label="$3"
  shift 3

  echo "attempted=$attempt_name"
  echo "native_command=$native_command_label"
  echo "runner=$runner_label"

  output_file="$(mktemp "${TMPDIR:-/tmp}/best-copilot-claude-init.XXXXXX")"
  run_with_timeout "$output_file" "$@"
  command_status=$?

  head -c 6000 "$output_file"
  rm -f "$output_file"

  if [ "$command_status" -eq 124 ] || [ "$command_status" -eq 142 ]; then
    echo
    echo "status=claude_init_timeout"
    echo "timeout_seconds=$timeout_seconds"
    return 70
  fi

  if [ "$command_status" -ne 0 ]; then
    echo
    echo "status=claude_init_failed"
    echo "exit_code=$command_status"
    return "$command_status"
  fi

  echo
  if emit_success_if_artifact_exists; then
    return 0
  fi

  echo "status=no_write"
  echo "missing=.github/instructions/project.instructions.md|CLAUDE.md|AGENTS.md"
  return 70
}

local_init_skill_path="$(find_local_init_skill || true)"
if [ -n "$local_init_skill_path" ]; then
  echo "local_init_skill=$local_init_skill_path"
  local_init_prompt="Use the target-local Claude Code init skill at ${local_init_skill_path} to initialize this repository. If the runtime exposes it as a slash command, invoke that target-local skill rather than Claude's built-in /init. Write the resulting repository init artifact to disk."
  run_claude_init_attempt "target_local_init_skill" "claude --bare --permission-mode acceptEdits -p <target-local init skill>" "target-local init skill: ${local_init_skill_path}" claude --bare --permission-mode acceptEdits -p "$local_init_prompt"
  local_status=$?
  if [ "$local_status" -eq 0 ]; then
    exit 0
  fi
  echo
  echo "local_init_skill_status=fallback_to_claude_native_slash_init"
fi

run_claude_init_attempt "claude_native_slash_init" "claude --bare --permission-mode acceptEdits -p /init" "/init" claude --bare --permission-mode acceptEdits -p "/init"
exit $?
