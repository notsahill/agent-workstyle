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
cat > api/orders.py <<'EOF'
STATUSES = ("PENDING", "PAID", "SHIPPED")


def order_response(order):
    return {"id": order["id"], "status": order["status"], "total": order["total_cents"]}
EOF
mkdir -p clients
cat > clients/__init__.py <<'EOF'

EOF
mkdir -p clients
cat > clients/mobile_sync.py <<'EOF'
# Mirrors the shape the mobile app reads from GET /orders/<id>.
def to_mobile(resp):
    return {"orderId": resp["id"], "amountCents": resp["total"]}
EOF
mkdir -p clients
cat > clients/status_badge.py <<'EOF'
BADGES = {"PENDING": "grey", "PAID": "green", "SHIPPED": "blue"}


def badge(status):
    return BADGES[status]
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
mkdir -p api
cat > api/orders.py <<'EOF'
STATUSES = ("PENDING", "PAID", "SHIPPED", "REFUNDED")


def order_response(order):
    return {"id": order["id"], "status": order["status"], "amount": order["total_cents"]}
EOF
git add -A
git commit -qm 'Rename total to amount and add REFUNDED status'
