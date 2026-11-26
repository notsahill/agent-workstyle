#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > discounts.py <<'EOF'
def apply(amount_cents, percent):
    return amount_cents - amount_cents * percent // 100
EOF
cat > checkout.py <<'EOF'
from discounts import apply


def charge_amount(cart_cents, coupon_percent):
    return apply(cart_cents, coupon_percent)
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > discounts.py <<'EOF'
def apply(amount_cents, percent):
    if percent > 100:
        percent = 100
    return amount_cents + amount_cents * percent // 100
EOF
git add -A
git commit -qm 'Cap discount percent at 100'
