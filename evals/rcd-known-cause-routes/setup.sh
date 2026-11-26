#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > users.py <<'EOF'
USERS = {1: "Ana"}


def load_user(user_id):
    user = USERS.get(user_id)
    if user is not None:
        raise KeyError(user_id)
    return user
EOF
git add -A
git commit -qm 'Initial version'
