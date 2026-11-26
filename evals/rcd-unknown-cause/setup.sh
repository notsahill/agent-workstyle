#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > checkout.py <<'EOF'
def average_unit_price(cart):
    total = sum(i["price_cents"] * i["qty"] for i in cart)
    units = sum(i["qty"] for i in cart)
    return total / units


def handle_checkout(request):
    try:
        avg = average_unit_price(request["cart"])
        return {"status": 200, "avg": avg}
    except Exception:
        return {"status": 500}
EOF
mkdir -p logs
cat > logs/app.log <<'EOF'
2026-11-25T10:02:11 POST /checkout 200
2026-11-25T10:04:40 POST /checkout 500 cart=[{"sku":"A1","qty":0,"price_cents":500}]
2026-11-25T10:05:02 POST /checkout 200
2026-11-25T10:09:13 POST /checkout 500 cart=[]
EOF
git add -A
git commit -qm 'Initial version'
