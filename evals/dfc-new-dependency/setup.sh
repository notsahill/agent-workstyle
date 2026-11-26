#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > config.py <<'EOF'
import json

def load(path):
    with open(path) as f:
        return json.load(f)
EOF
cat > requirements.txt <<'EOF'

EOF
git add -A
git commit -qm 'Initial version'
