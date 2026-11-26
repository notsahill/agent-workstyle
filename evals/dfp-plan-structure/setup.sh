#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
mkdir -p api
cat > api/__init__.py <<'EOF'

EOF
mkdir -p api
cat > api/middleware.py <<'EOF'
MIDDLEWARE = []


def register(fn):
    MIDDLEWARE.append(fn)
    return fn
EOF
mkdir -p api
cat > api/redis_client.py <<'EOF'
def get_client():
    import redis
    return redis.Redis()
EOF
git add -A
git commit -qm 'Initial version'
