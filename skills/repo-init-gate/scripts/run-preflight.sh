#!/usr/bin/env bash
set -u

target_dir="${1:-$PWD}"
compatibility="${2:-claude}"
contract_version="0.7.0"
force_reinit="${BEST_COPILOT_FORCE_REINIT:-0}"
script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
skills_dir="$(CDPATH= cd -- "$script_dir/../.." && pwd)"
scan_helper="$skills_dir/repo-init-scan/scripts/bootstrap-after-gate-failure.sh"

if [ ! -d "$target_dir" ]; then
  echo "## Repo Init Gate"
  echo "- gate_result: needs_init"
  echo "- next_action: run_repo_init_scan"
  echo "- evidence: target_root_best_copilot_md=unreadable, observed_version=none"
  echo
  echo "## Repo Init Scan"
  echo "- status: blocked"
  echo "- reason: invalid_target_dir"
  echo "BLOCKED invalid_target_dir"
  exit 64
fi

sentinel_path="$target_dir/best-copilot.md"

frontmatter_is_valid() {
  [ -f "$sentinel_path" ] && [ -r "$sentinel_path" ] && awk '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && /^---[[:space:]]*$/ { found = 1; exit }
    END { exit(found ? 0 : 1) }
  ' "$sentinel_path" 2>/dev/null
}

observed_version() {
  if [ ! -f "$sentinel_path" ] || [ ! -r "$sentinel_path" ]; then
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
  ' "$sentinel_path" 2>/dev/null)"
  if [ -n "$version" ]; then
    echo "$version"
  else
    echo "none"
  fi
}

sentinel_version_is_current() {
  [ "$(observed_version)" = "$contract_version" ]
}

sentinel_fast_path_ready() {
  [ "$force_reinit" != "1" ] && sentinel_version_is_current
}

artifact_state() {
  if [ -f "$sentinel_path" ] && [ -r "$sentinel_path" ]; then
    echo "present"
  elif [ -e "$sentinel_path" ]; then
    echo "unreadable"
  else
    echo "missing"
  fi
}

gate_result_for_current_state() {
  if sentinel_fast_path_ready; then
    echo "ready"
    return
  fi

  if [ ! -e "$sentinel_path" ] || [ ! -r "$sentinel_path" ]; then
    echo "needs_init"
    return
  fi

  if ! frontmatter_is_valid; then
    echo "invalid_sentinel"
    return
  fi

  observed="$(observed_version)"
  if [ "$force_reinit" = "1" ] && [ "$observed" = "$contract_version" ]; then
    echo "needs_init"
    return
  fi

  if [ "$observed" != "none" ] && [ "$observed" != "$contract_version" ]; then
    echo "version_mismatch"
  else
    echo "invalid_sentinel"
  fi
}

gate_result="$(gate_result_for_current_state)"
observed="$(observed_version)"
state="$(artifact_state)"

echo "## Repo Init Gate"
echo "- gate_result: $gate_result"

if [ "$gate_result" = "ready" ]; then
  echo "- next_action: skip_repo_init_scan"
  echo "- evidence: target_root_best_copilot_md=$state, observed_version=$observed"
  echo
  echo "## Repo Init Scan"
  echo "INIT_SCAN=SKIP_SENTINEL_READY"
  exit 0
fi

echo "- next_action: run_repo_init_scan"
echo "- evidence: target_root_best_copilot_md=$state, observed_version=$observed"
echo
echo "## Repo Init Scan"

if [ ! -f "$scan_helper" ]; then
  echo "- status: blocked"
  echo "- reason: scan_helper_unavailable"
  echo "- expected_helper: $scan_helper"
  echo "BLOCKED tool_execution_unavailable"
  exit 70
fi

BEST_COPILOT_SCAN_EMIT_GATE=0 bash "$scan_helper" "$target_dir" "$compatibility"
