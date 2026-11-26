#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > search.py <<'EOF'
PRODUCTS = ["red shoe", "blue shoe", "red hat"]
EOF
mkdir -p docs/plans
cat > docs/plans/2026-11-10-search.md <<'EOF'
# Product search plan

**Goal:** Add a substring search over products.

## Task 1: search function
- [ ] Write a failing test for `search("red")` returning both red items.
- [ ] Implement `search(term)` in search.py.

## Task 2: limit parameter
- [ ] Write a failing test for `search("shoe", limit=1)`.
- [ ] Add `limit`.

## Task 3: case-insensitive search
- [ ] Write a failing test for `search("RED")`.
- [ ] Lowercase both sides.
EOF
git add -A
git commit -qm 'Initial version'
