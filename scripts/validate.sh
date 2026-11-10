#!/bin/sh
set -eu

AGENT_WORKSTYLE_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
AGENT_WORKSTYLE_CODEX_ROOT=${CODEX_HOME:-${HOME:?HOME is not set}/.codex}
AGENT_WORKSTYLE_QUICK_VALIDATE="$AGENT_WORKSTYLE_CODEX_ROOT/skills/.system/skill-creator/scripts/quick_validate.py"
AGENT_WORKSTYLE_UV_CACHE="${TMPDIR:-/tmp}/agent-workstyle-uv-cache"

if [ -f "$AGENT_WORKSTYLE_QUICK_VALIDATE" ]; then
  if python3 -c 'import yaml' >/dev/null 2>&1; then
    AGENT_WORKSTYLE_PY_RUNNER=python3
  elif command -v uv >/dev/null 2>&1; then
    AGENT_WORKSTYLE_PY_RUNNER=uv
  else
    printf 'error: validating Codex skills requires PyYAML or uv\n' >&2
    exit 1
  fi
  for AGENT_WORKSTYLE_SKILL_FILE in "$AGENT_WORKSTYLE_ROOT"/skills/*/SKILL.md; do
    AGENT_WORKSTYLE_SKILL_DIR=$(dirname -- "$AGENT_WORKSTYLE_SKILL_FILE")
    if [ "$AGENT_WORKSTYLE_PY_RUNNER" = python3 ]; then
      python3 "$AGENT_WORKSTYLE_QUICK_VALIDATE" "$AGENT_WORKSTYLE_SKILL_DIR"
    else
      UV_CACHE_DIR="$AGENT_WORKSTYLE_UV_CACHE" uv run --with pyyaml "$AGENT_WORKSTYLE_QUICK_VALIDATE" "$AGENT_WORKSTYLE_SKILL_DIR"
    fi
  done
else
  printf 'warning: Codex skill validator not found at %s\n' "$AGENT_WORKSTYLE_QUICK_VALIDATE" >&2
fi

if command -v claude >/dev/null 2>&1; then
  claude plugin validate --strict "$AGENT_WORKSTYLE_ROOT"
else
  printf 'warning: Claude Code is not installed; skipping plugin validation\n' >&2
fi

"$AGENT_WORKSTYLE_ROOT/scripts/test-installer.sh"
