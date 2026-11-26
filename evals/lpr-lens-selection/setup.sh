#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > cart.py <<'EOF'
def total(items):
    return sum(i["price"] * i["qty"] for i in items)
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > cart.py <<'EOF'
def total(items):
    # first row is a header in CSV imports
    return sum(i["price"] * i["qty"] for i in items[1:])
EOF
git add -A
git commit -qm 'Skip header row'
