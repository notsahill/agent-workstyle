#!/bin/sh
set -eu

AGENT_WORKSTYLE_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
AGENT_WORKSTYLE_TARGET_HOME=${HOME:?HOME is not set}
AGENT_WORKSTYLE_ACTION=install
AGENT_WORKSTYLE_DRY_RUN=0

usage() {
  printf '%s\n' \
    "Usage: scripts/install.sh [install|status|uninstall] [--dry-run] [--home PATH]" \
    "" \
    "Links the canonical skills into:" \
    "  PATH/.agents/skills   (Codex)" \
    "  PATH/.claude/skills   (Claude Code)"
}

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    install|status|uninstall)
      AGENT_WORKSTYLE_ACTION=$1
      ;;
    --dry-run)
      AGENT_WORKSTYLE_DRY_RUN=1
      ;;
    --home)
      [ "$#" -ge 2 ] || fail "--home requires a path"
      AGENT_WORKSTYLE_TARGET_HOME=$2
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
  shift
done

case "$AGENT_WORKSTYLE_TARGET_HOME" in
  /*) ;;
  *) fail "target home must be an absolute path" ;;
esac
[ "$AGENT_WORKSTYLE_TARGET_HOME" != "/" ] || fail "target home cannot be /"

source_for() {
  printf '%s/skills/%s\n' "$AGENT_WORKSTYLE_ROOT" "$1"
}

target_for() {
  printf '%s/%s\n' "$1" "$2"
}

check_install_target() {
  AGENT_WORKSTYLE_SOURCE=$1
  AGENT_WORKSTYLE_TARGET=$2

  if [ -L "$AGENT_WORKSTYLE_TARGET" ]; then
    AGENT_WORKSTYLE_EXISTING=$(readlink "$AGENT_WORKSTYLE_TARGET")
    [ "$AGENT_WORKSTYLE_EXISTING" = "$AGENT_WORKSTYLE_SOURCE" ] && return 0
    fail "conflict at $AGENT_WORKSTYLE_TARGET (links to $AGENT_WORKSTYLE_EXISTING)"
  fi

  [ ! -e "$AGENT_WORKSTYLE_TARGET" ] || fail "conflict at $AGENT_WORKSTYLE_TARGET"
}

install_target() {
  AGENT_WORKSTYLE_SOURCE=$1
  AGENT_WORKSTYLE_TARGET=$2

  if [ -L "$AGENT_WORKSTYLE_TARGET" ] && [ "$(readlink "$AGENT_WORKSTYLE_TARGET")" = "$AGENT_WORKSTYLE_SOURCE" ]; then
    printf 'already linked: %s\n' "$AGENT_WORKSTYLE_TARGET"
    return
  fi

  if [ "$AGENT_WORKSTYLE_DRY_RUN" -eq 1 ]; then
    printf 'would link: %s -> %s\n' "$AGENT_WORKSTYLE_TARGET" "$AGENT_WORKSTYLE_SOURCE"
    return
  fi

  mkdir -p "$(dirname -- "$AGENT_WORKSTYLE_TARGET")"
  ln -s "$AGENT_WORKSTYLE_SOURCE" "$AGENT_WORKSTYLE_TARGET"
  printf 'linked: %s -> %s\n' "$AGENT_WORKSTYLE_TARGET" "$AGENT_WORKSTYLE_SOURCE"
}

status_target() {
  AGENT_WORKSTYLE_SOURCE=$1
  AGENT_WORKSTYLE_TARGET=$2

  if [ -L "$AGENT_WORKSTYLE_TARGET" ]; then
    AGENT_WORKSTYLE_EXISTING=$(readlink "$AGENT_WORKSTYLE_TARGET")
    if [ "$AGENT_WORKSTYLE_EXISTING" = "$AGENT_WORKSTYLE_SOURCE" ]; then
      printf 'installed: %s\n' "$AGENT_WORKSTYLE_TARGET"
    else
      printf 'conflict: %s -> %s\n' "$AGENT_WORKSTYLE_TARGET" "$AGENT_WORKSTYLE_EXISTING"
    fi
  elif [ -e "$AGENT_WORKSTYLE_TARGET" ]; then
    printf 'conflict: %s is not a symlink\n' "$AGENT_WORKSTYLE_TARGET"
  else
    printf 'not installed: %s\n' "$AGENT_WORKSTYLE_TARGET"
  fi
}

uninstall_target() {
  AGENT_WORKSTYLE_SOURCE=$1
  AGENT_WORKSTYLE_TARGET=$2

  if [ -L "$AGENT_WORKSTYLE_TARGET" ] && [ "$(readlink "$AGENT_WORKSTYLE_TARGET")" = "$AGENT_WORKSTYLE_SOURCE" ]; then
    if [ "$AGENT_WORKSTYLE_DRY_RUN" -eq 1 ]; then
      printf 'would unlink: %s\n' "$AGENT_WORKSTYLE_TARGET"
    else
      unlink "$AGENT_WORKSTYLE_TARGET"
      printf 'unlinked: %s\n' "$AGENT_WORKSTYLE_TARGET"
    fi
  elif [ -e "$AGENT_WORKSTYLE_TARGET" ] || [ -L "$AGENT_WORKSTYLE_TARGET" ]; then
    printf 'left untouched: %s does not point to this repository\n' "$AGENT_WORKSTYLE_TARGET"
  else
    printf 'not installed: %s\n' "$AGENT_WORKSTYLE_TARGET"
  fi
}

AGENT_WORKSTYLE_CODEX_BASE="$AGENT_WORKSTYLE_TARGET_HOME/.agents/skills"
AGENT_WORKSTYLE_CLAUDE_BASE="$AGENT_WORKSTYLE_TARGET_HOME/.claude/skills"

if [ "$AGENT_WORKSTYLE_ACTION" = install ]; then
  for AGENT_WORKSTYLE_SKILL in decision-first-code lens-pr-review; do
    AGENT_WORKSTYLE_SOURCE=$(source_for "$AGENT_WORKSTYLE_SKILL")
    check_install_target "$AGENT_WORKSTYLE_SOURCE" "$(target_for "$AGENT_WORKSTYLE_CODEX_BASE" "$AGENT_WORKSTYLE_SKILL")"
    check_install_target "$AGENT_WORKSTYLE_SOURCE" "$(target_for "$AGENT_WORKSTYLE_CLAUDE_BASE" "$AGENT_WORKSTYLE_SKILL")"
  done
fi

for AGENT_WORKSTYLE_SKILL in decision-first-code lens-pr-review; do
  AGENT_WORKSTYLE_SOURCE=$(source_for "$AGENT_WORKSTYLE_SKILL")
  for AGENT_WORKSTYLE_BASE in "$AGENT_WORKSTYLE_CODEX_BASE" "$AGENT_WORKSTYLE_CLAUDE_BASE"; do
    AGENT_WORKSTYLE_TARGET=$(target_for "$AGENT_WORKSTYLE_BASE" "$AGENT_WORKSTYLE_SKILL")
    case "$AGENT_WORKSTYLE_ACTION" in
      install) install_target "$AGENT_WORKSTYLE_SOURCE" "$AGENT_WORKSTYLE_TARGET" ;;
      status) status_target "$AGENT_WORKSTYLE_SOURCE" "$AGENT_WORKSTYLE_TARGET" ;;
      uninstall) uninstall_target "$AGENT_WORKSTYLE_SOURCE" "$AGENT_WORKSTYLE_TARGET" ;;
    esac
  done
done

