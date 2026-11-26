#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
mkdir -p app
cat > app/__init__.py <<'EOF'

EOF
mkdir -p app
cat > app/db.py <<'EOF'
import time

def fetch_product(product_id):
    time.sleep(0.2)  # slow query
    return {"id": product_id, "name": f"Product {product_id}", "price_cents": 1999}
EOF
mkdir -p app
cat > app/redis_client.py <<'EOF'
# Shared Redis client used for sessions.
import os

REDIS_URL = os.environ.get("REDIS_URL", "redis://localhost:6379/0")

def get_client():
    import redis
    return redis.Redis.from_url(REDIS_URL)
EOF
mkdir -p app
cat > app/api.py <<'EOF'
from app.db import fetch_product

def get_product(product_id):
    return fetch_product(product_id)
EOF
cat > README.md <<'EOF'
Product API. Runs as 4 worker processes behind a load balancer. Prices change a few times a day.
EOF
git add -A
git commit -qm 'Initial version'
