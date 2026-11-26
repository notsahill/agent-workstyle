#!/bin/sh
# Run the behavioral eval suite in evals/ with `claude plugin eval`.
# Each run calls the model on your own Claude login and costs money; run it by hand,
# not from validate.sh. Extra arguments pass through, for example:
#   ./scripts/eval.sh --case 'lpr-*' --runs 1
set -eu

AGENT_WORKSTYLE_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)

if ! command -v claude >/dev/null 2>&1; then
  printf 'error: Claude Code is not installed\n' >&2
  exit 1
fi

# --scaffold runs each case's setup.sh, which builds its fixture repository.
# --ablation none skips the no-plugin baseline arm, halving the cost.
exec claude plugin eval "$AGENT_WORKSTYLE_ROOT" \
  --scaffold \
  --trust-plugin \
  --no-publish \
  --ablation none \
  --allow-tools Bash Edit Write \
  "$@"
