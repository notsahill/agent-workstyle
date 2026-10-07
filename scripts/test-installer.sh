#!/bin/sh
set -eu

AGENT_WORKSTYLE_TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/agent-workstyle-test.XXXXXX")
AGENT_WORKSTYLE_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/install.sh

cleanup() {
  case "$AGENT_WORKSTYLE_TEST_ROOT" in
    "${TMPDIR:-/tmp}"/agent-workstyle-test.*) rm -rf -- "$AGENT_WORKSTYLE_TEST_ROOT" ;;
    *) printf 'refusing to clean unexpected path: %s\n' "$AGENT_WORKSTYLE_TEST_ROOT" >&2 ;;
  esac
}
trap cleanup EXIT HUP INT TERM

assert_link() {
  [ -L "$1" ] || {
    printf 'expected symlink: %s\n' "$1" >&2
    exit 1
  }
}

assert_absent() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    printf 'expected absent path: %s\n' "$1" >&2
    exit 1
  fi
}

AGENT_WORKSTYLE_TEST_HOME="$AGENT_WORKSTYLE_TEST_ROOT/home"
mkdir -p "$AGENT_WORKSTYLE_TEST_HOME"

"$AGENT_WORKSTYLE_SCRIPT" install --dry-run --home "$AGENT_WORKSTYLE_TEST_HOME"
assert_absent "$AGENT_WORKSTYLE_TEST_HOME/.agents/skills/sahil-code"

"$AGENT_WORKSTYLE_SCRIPT" install --home "$AGENT_WORKSTYLE_TEST_HOME"
"$AGENT_WORKSTYLE_SCRIPT" install --home "$AGENT_WORKSTYLE_TEST_HOME"
"$AGENT_WORKSTYLE_SCRIPT" status --home "$AGENT_WORKSTYLE_TEST_HOME"

for AGENT_WORKSTYLE_SKILL in sahil-code sahil-pr-review; do
  assert_link "$AGENT_WORKSTYLE_TEST_HOME/.agents/skills/$AGENT_WORKSTYLE_SKILL"
  assert_link "$AGENT_WORKSTYLE_TEST_HOME/.claude/skills/$AGENT_WORKSTYLE_SKILL"
done

"$AGENT_WORKSTYLE_SCRIPT" uninstall --home "$AGENT_WORKSTYLE_TEST_HOME"
for AGENT_WORKSTYLE_SKILL in sahil-code sahil-pr-review; do
  assert_absent "$AGENT_WORKSTYLE_TEST_HOME/.agents/skills/$AGENT_WORKSTYLE_SKILL"
  assert_absent "$AGENT_WORKSTYLE_TEST_HOME/.claude/skills/$AGENT_WORKSTYLE_SKILL"
done

mkdir -p "$AGENT_WORKSTYLE_TEST_HOME/.agents/skills/sahil-code"
if "$AGENT_WORKSTYLE_SCRIPT" install --home "$AGENT_WORKSTYLE_TEST_HOME"; then
  printf 'expected conflict failure\n' >&2
  exit 1
fi
assert_absent "$AGENT_WORKSTYLE_TEST_HOME/.agents/skills/sahil-pr-review"
assert_absent "$AGENT_WORKSTYLE_TEST_HOME/.claude/skills/sahil-code"

printf 'installer tests passed\n'

