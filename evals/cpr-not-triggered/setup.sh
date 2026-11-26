#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > greet.py <<'EOF'
def greet(name):
    return "Hi " + name
EOF
mkdir -p docs/plans
cat > docs/plans/greeting.md <<'EOF'
# Greeting plan

1. Change `greet` to return "Hello, <name>!".
2. Add a test for it.
EOF
git add -A
git commit -qm 'Initial version'
