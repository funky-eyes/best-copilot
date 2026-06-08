#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"
compatibility="${2:-claude}"
contract_version="0.7.0"
force_reinit="${BEST_COPILOT_FORCE_REINIT:-0}"
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

frontmatter_is_valid() {
  [ -f "best-copilot.md" ] && [ -r "best-copilot.md" ] && awk '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && /^---[[:space:]]*$/ { found = 1; exit }
    END { exit(found ? 0 : 1) }
  ' "best-copilot.md" 2>/dev/null
}

observed_version() {
  if [ ! -f "best-copilot.md" ] || [ ! -r "best-copilot.md" ]; then
    echo "none"
    return
  fi

  if ! frontmatter_is_valid; then
    echo "none"
    return
  fi

  version="$(awk -F: '
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    /^[[:space:]]*version[[:space:]]*:/ {
      v = $2
      sub(/^[[:space:]]+/, "", v)
      sub(/[[:space:]]+$/, "", v)
      gsub(/^["\047]|["\047]$/, "", v)
      print v
      exit
    }
  ' "best-copilot.md" 2>/dev/null)"
  if [ -n "$version" ]; then
    echo "$version"
  else
    echo "none"
  fi
}

sentinel_is_current() {
  [ "$(observed_version)" = "$contract_version" ]
}

sentinel_fast_path_ready() {
  [ "$force_reinit" != "1" ] && sentinel_is_current
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

emit_scan_gate="${BEST_COPILOT_SCAN_EMIT_GATE:-1}"

if sentinel_fast_path_ready; then
  if [ "$emit_scan_gate" != "0" ]; then
    echo "## Repo Init Gate"
    echo "- gate_result: ready"
    echo "- next_action: skip_repo_init_scan"
    echo "- evidence: target_root_best_copilot_md=present, observed_version=$(observed_version)"
    echo
  fi
  echo "## Repo Init Scan"
  echo "INIT_SCAN=SKIP_SENTINEL_READY"
  exit 0
else
  if [ "$emit_scan_gate" != "0" ]; then
    echo "## Repo Init Gate"
    echo "- status: needs_init"
    echo "- sentinel: missing_or_invalid"
  fi
fi
if [ "$emit_scan_gate" != "0" ]; then
  echo
fi

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
