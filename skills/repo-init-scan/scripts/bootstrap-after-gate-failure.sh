#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"
compatibility="${2:-claude}"
contract_version="0.6.0"
script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
skills_dir="$(CDPATH= cd -- "$script_dir/../.." && pwd)"
claude_official_helper="$skills_dir/repo-init-official/scripts/run-claude-native-init.sh"
copilot_official_helper="$skills_dir/repo-init-official/scripts/run-copilot-native-init.sh"
manual_helper="$skills_dir/repo-init-manual-fallback/scripts/bootstrap-target-scaffold.sh"

if [ ! -d "$target_dir" ]; then
  echo "BLOCKED invalid_target_dir"
  echo "target_dir=$target_dir"
  exit 64
fi

cd "$target_dir" || exit 64

is_claude_compat() {
  [ "$compatibility" = "claude" ] || [ "$compatibility" = "claude-code" ]
}

sentinel_is_current() {
  [ -f "best-copilot.md" ] && cmp -s "best-copilot.md" - <<EOF
---
version: "$contract_version"
---
EOF
}

required_paths=(
  ".github/instructions/project.instructions.md"
  ".github/instructions/must.instructions.md"
  ".github/instructions/skills-index.instructions.md"
  "memories/README.md"
  "memories/repo/INDEX.md"
  "memories/repo/current-workstreams.md"
  "memories/repo/project-state.md"
  "memories/repo/workflow-rules.md"
  "memories/repo/decisions.md"
  "memories/repo/logs/README.md"
  "memories/repo/archive/deprecated-decisions.md"
  "spec/INDEX.md"
  "spec/templates/requirements-template.md"
  "spec/templates/design-template.md"
  "spec/templates/tasks-template.md"
)

if is_claude_compat; then
  required_paths+=("CLAUDE.md")
fi

collect_artifact_evidence() {
  missing_paths=""
  verified_paths=""
  for rel_path in "${required_paths[@]}"; do
    if [ -f "$rel_path" ]; then
      verified_paths="${verified_paths}${rel_path}
"
    else
      missing_paths="${missing_paths}${rel_path}
"
    fi
  done

  if sentinel_is_current; then
    verified_paths="${verified_paths}best-copilot.md
"
  else
    missing_paths="${missing_paths}best-copilot.md
"
  fi
}

echo "## Repo Init Gate"

if sentinel_is_current; then
  collect_artifact_evidence
  if [ -z "$missing_paths" ]; then
    echo "- status: ready"
    echo "- sentinel: valid"
    echo
    echo "## Init Summary"
    echo "- official_stage: skipped"
    echo "- official_attempted: none"
    echo "- manual_fallback_stage: skipped"
    echo "- required_artifacts_verified: yes"
    echo "- sentinel_written: yes"
    echo "- next_task_ready: yes"
    echo "- verified_paths:"
    printf '%s' "$verified_paths" | sed 's/^/  - /'
    echo "- missing_paths: none"
    exit 0
  fi
  echo "- status: needs_repair"
  echo "- sentinel: valid"
  echo "- missing_artifacts:"
  printf '%s' "$missing_paths" | sed 's/^/  - /'
else
  echo "- status: needs_init"
  echo "- sentinel: missing_or_invalid"
fi
echo

official_stage="official_init_unavailable"
official_attempted="none"

extract_helper_field() {
  field_name="$1"
  printf '%s\n' "$official_output" | awk -F= -v field="$field_name" '
    $1 == field {
      if (seen[$2]) {
        next
      }
      seen[$2] = 1
      if (value == "") {
        value = $2
      } else {
        value = value "," $2
      }
    }
    END {
      print value
    }
  '
}

if [ "$compatibility" = "claude" ] || [ "$compatibility" = "claude-code" ]; then
  official_attempted="claude_native_slash_init"
  if [ -x "$claude_official_helper" ] || [ -f "$claude_official_helper" ]; then
    official_output="$(bash "$claude_official_helper" "$target_dir" 2>&1)"
    official_exit=$?
    helper_attempted="$(extract_helper_field attempted)"
    helper_native_command="$(extract_helper_field native_command)"
    if [ -n "$helper_attempted" ]; then
      official_attempted="$helper_attempted"
    fi
    printf '%s\n' "## Repo Init Official"
    printf '%s\n' "- attempted: $official_attempted"
    if [ -n "$helper_native_command" ]; then
      printf '%s\n' "- native_command: $helper_native_command"
    else
      printf '%s\n' "- native_command: /init"
    fi
    printf '%s\n' "$official_output" | head -c 6000
    printf '\n'
    if [ "$official_exit" -eq 0 ] && printf '%s\n' "$official_output" | grep -Fq 'status=success'; then
      official_stage="success"
    elif printf '%s\n' "$official_output" | grep -Fq 'status=claude_init_timeout'; then
      official_stage="official_init_incomplete"
    else
      official_stage="official_init_no_write"
    fi
  fi
elif [ "$compatibility" = "copilot" ] || [ "$compatibility" = "copilot-cli" ] || [ "$compatibility" = "github-copilot" ]; then
  official_attempted="copilot_init"
  if [ -x "$copilot_official_helper" ] || [ -f "$copilot_official_helper" ]; then
    official_output="$(bash "$copilot_official_helper" "$target_dir" 2>&1)"
    official_exit=$?
    helper_attempted="$(extract_helper_field attempted)"
    helper_native_command="$(extract_helper_field native_command)"
    if [ -n "$helper_attempted" ]; then
      official_attempted="$helper_attempted"
    fi
    printf '%s\n' "## Repo Init Official"
    printf '%s\n' "- attempted: $official_attempted"
    if [ -n "$helper_native_command" ]; then
      printf '%s\n' "- native_command: $helper_native_command"
    else
      printf '%s\n' "- native_command: copilot init"
    fi
    printf '%s\n' "$official_output" | head -c 6000
    printf '\n'
    if [ "$official_exit" -eq 0 ] && printf '%s\n' "$official_output" | grep -Fq 'status=success'; then
      official_stage="success"
    elif printf '%s\n' "$official_output" | grep -Fq 'status=copilot_init_timeout'; then
      official_stage="official_init_incomplete"
    elif printf '%s\n' "$official_output" | grep -Eq 'status=copilot_(cli|auth)_missing'; then
      official_stage="official_init_unavailable"
    else
      official_stage="official_init_no_write"
    fi
  fi
fi

if [ ! -f "$manual_helper" ]; then
  echo "## Init Summary"
  echo "- official_stage: $official_stage"
  echo "- official_attempted: $official_attempted"
  echo "- manual_fallback_stage: blocked"
  echo "- required_artifacts_verified: no"
  echo "- sentinel_written: no"
  echo "- next_task_ready: no"
  echo "- verified_paths: none"
  echo "- missing_paths: repo-init-manual-fallback/scripts/bootstrap-target-scaffold.sh"
  echo "BLOCKED first_use_gate_incomplete"
  exit 70
fi

manual_output="$(bash "$manual_helper" "$target_dir" "$compatibility" 2>&1)"
manual_exit=$?
printf '%s\n' "$manual_output" | head -c 12000
printf '\n'

collect_artifact_evidence

echo "## Init Summary"
echo "- official_stage: $official_stage"
echo "- official_attempted: $official_attempted"

if [ "$manual_exit" -eq 0 ] && [ -z "$missing_paths" ] && sentinel_is_current; then
  echo "- manual_fallback_stage: success"
  echo "- required_artifacts_verified: yes"
  echo "- sentinel_written: yes"
  echo "- next_task_ready: yes"
  echo "- verified_paths:"
  printf '%s' "$verified_paths" | sed 's/^/  - /'
  echo "- missing_paths: none"
  exit 0
fi

echo "- manual_fallback_stage: blocked"
echo "- required_artifacts_verified: no"
if sentinel_is_current; then
  echo "- sentinel_written: yes"
else
  echo "- sentinel_written: no"
fi
echo "- next_task_ready: no"
echo "- verified_paths:"
if [ -n "$verified_paths" ]; then
  printf '%s' "$verified_paths" | sed 's/^/  - /'
else
  echo "  - none"
fi
echo "- missing_paths:"
if [ -n "$missing_paths" ]; then
  printf '%s' "$missing_paths" | sed 's/^/  - /'
else
  echo "  - manual_helper_failed_without_missing_path"
fi
echo "BLOCKED first_use_gate_incomplete"
exit 70
