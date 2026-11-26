#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > payments.py <<'EOF'
CHARGED = []


def charge(customer_id, amount_cents):
    CHARGED.append((customer_id, amount_cents))
    return len(CHARGED)


def on_webhook(event):
    if event["type"] == "checkout.completed":
        charge(event["customer_id"], event["amount_cents"])
EOF
git add -A
git commit -qm 'Initial version'
