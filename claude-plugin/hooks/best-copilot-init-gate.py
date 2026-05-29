#!/usr/bin/env python3
"""Claude Code hook that blocks business-source tools until repo init passes."""

from __future__ import annotations

import json
import os
from pathlib import Path
import re
import sys
from typing import Any


EXPECTED_VERSION = "0.6.0"

ALLOWED_EXACT_PATHS = {
    "best-copilot.md",
    "AGENTS.md",
    "CLAUDE.md",
    "README.md",
    "README.zh-CN.md",
    "README.ja.md",
    "README.ko.md",
    "package.json",
    "pnpm-lock.yaml",
    "package-lock.json",
    "yarn.lock",
    "pom.xml",
    "build.gradle",
    "settings.gradle",
    "gradlew",
    "Makefile",
    "pyproject.toml",
    "requirements.txt",
    "go.mod",
    "Cargo.toml",
    "plugin.json",
    "marketplace.json",
    "settings.json",
}

ALLOWED_PREFIXES = (
    ".github/instructions/",
    ".claude/",
    "memories/",
    "spec/",
)

INIT_EXPANSION_COMMANDS = {
    "repo-init-gate",
    "repo-init-scan",
    "repo-init-official",
    "repo-init-manual-fallback",
    "target-instructions-bootstrap",
    "target-memory-bootstrap",
    "target-spec-bootstrap",
    "senior-project-expert",
}

INIT_COMMAND_MARKERS = (
    "repo-init",
    "run-claude-native-init.sh",
    "best-copilot.md",
    ".github/instructions",
    "memories/repo",
    "spec/templates",
    "CLAUDE.md",
    "AGENTS.md",
    "claude --bare",
    '"/init"',
    "'/init'",
)

SAFE_DISCOVERY_COMMANDS = (
    "pwd",
    "ls",
    "git status",
    "git rev-parse",
    "find . -maxdepth 1",
    "find . -maxdepth 2",
    "find . -maxdepth 3",
)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError as exc:
        deny_pre_tool_use(f"best-copilot hook could not parse input JSON: {exc}")
        return 0

    project_dir = Path(
        os.environ.get("CLAUDE_PROJECT_DIR") or payload.get("cwd") or os.getcwd()
    ).resolve()

    if sentinel_ready(project_dir):
        return 0

    event_name = str(payload.get("hook_event_name", ""))
    if event_name == "UserPromptSubmit":
        inject_init_context()
        return 0

    if event_name == "UserPromptExpansion":
        handle_user_prompt_expansion(payload)
        return 0

    if event_name == "PreToolUse" and is_tool_allowed_before_init(payload, project_dir):
        return 0

    if event_name == "PreToolUse":
        tool_name = payload.get("tool_name", "unknown")
        deny_pre_tool_use(
            "best-copilot init gate blocked "
            f"{tool_name}: target best-copilot.md is missing, invalid, or not version "
            f"{EXPECTED_VERSION}. Run repo-init-gate/repo-init-scan first. "
            "Before init completes, only sentinel reads, init bootstrap writes, and bounded root discovery are allowed."
        )
        return 0

    return 0


def sentinel_ready(project_dir: Path) -> bool:
    sentinel = project_dir / "best-copilot.md"
    if not sentinel.is_file():
        return False
    try:
        text = sentinel.read_text(encoding="utf-8", errors="replace")[:4096]
    except OSError:
        return False
    return bool(re.search(r'^version:\s*["\']?' + re.escape(EXPECTED_VERSION) + r'["\']?\s*$', text, re.MULTILINE))


def is_tool_allowed_before_init(payload: dict[str, Any], project_dir: Path) -> bool:
    tool_name = str(payload.get("tool_name", ""))
    tool_input = payload.get("tool_input") or {}

    if tool_name in {"Read", "Write", "Edit", "MultiEdit"}:
        file_path = tool_input.get("file_path") or tool_input.get("path")
        return bool(file_path and is_init_path_allowed(project_dir, str(file_path)))

    if tool_name == "Glob":
        base_path = tool_input.get("path") or str(project_dir)
        pattern = str(tool_input.get("pattern", ""))
        return is_init_path_allowed(project_dir, str(base_path)) and not looks_like_source_glob(pattern)

    if tool_name == "Grep":
        base_path = tool_input.get("path") or str(project_dir)
        glob = str(tool_input.get("glob", ""))
        return is_init_path_allowed(project_dir, str(base_path)) and not looks_like_source_glob(glob)

    if tool_name == "Bash":
        command = str(tool_input.get("command", ""))
        return is_init_bash_allowed(command)

    if tool_name.startswith("mcp__"):
        return False

    if tool_name in {"Agent", "Task"}:
        task_text = json.dumps(tool_input, ensure_ascii=False)
        return "repo-init" in task_text or "best-copilot.md" in task_text

    return False


def handle_user_prompt_expansion(payload: dict[str, Any]) -> None:
    command_name = str(payload.get("command_name", ""))
    normalized = command_name.removeprefix("best-copilot:")
    if normalized in INIT_EXPANSION_COMMANDS:
        inject_expansion_context()
        return

    if command_name.startswith("best-copilot:"):
        print(json.dumps({
            "decision": "block",
            "reason": (
                "best-copilot init gate blocked this slash command because target "
                f"best-copilot.md is missing, invalid, or not version {EXPECTED_VERSION}. "
                "Start with /best-copilot:repo-init-gate, /best-copilot:repo-init-scan, "
                "or the senior-project-expert entrypoint."
            ),
        }))


def is_init_path_allowed(project_dir: Path, raw_path: str) -> bool:
    path = Path(raw_path)
    if not path.is_absolute():
        path = project_dir / path
    try:
        rel = path.resolve().relative_to(project_dir)
    except (OSError, ValueError):
        return False

    rel_text = rel.as_posix()
    if rel_text in {".", ""}:
        return True
    return rel_text in ALLOWED_EXACT_PATHS or rel_text.startswith(ALLOWED_PREFIXES)


def looks_like_source_glob(pattern: str) -> bool:
    if not pattern:
        return False
    source_markers = ("src/", "core/", "app/", "lib/", "**/*.java", "**/*.ts", "**/*.js", "**/*.py")
    return any(marker in pattern for marker in source_markers)


def is_init_bash_allowed(command: str) -> bool:
    normalized = " ".join(command.strip().split())
    if not normalized:
        return False
    if any(marker in normalized for marker in INIT_COMMAND_MARKERS):
        return True
    return any(normalized.startswith(prefix) for prefix in SAFE_DISCOVERY_COMMANDS)


def inject_init_context() -> None:
    message = (
        "best-copilot init gate: target best-copilot.md is missing, invalid, or stale. "
        "Before business-source reads, codegraph, Agent dispatch, or implementation, run "
        "INIT_GATE -> INIT_SCAN -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION. "
        "Until init completes, PreToolUse hooks allow only sentinel reads, init bootstrap writes, "
        "and bounded root discovery."
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": message,
        }
    }))


def inject_expansion_context() -> None:
    message = (
        "best-copilot init gate: this init-capable slash command may proceed, but target "
        "best-copilot.md is missing, invalid, or stale. Complete INIT_GATE -> INIT_SCAN "
        "before business-source reads, codegraph, Agent dispatch, or implementation."
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptExpansion",
            "additionalContext": message,
        }
    }))


def deny_pre_tool_use(reason: str) -> None:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))


if __name__ == "__main__":
    raise SystemExit(main())