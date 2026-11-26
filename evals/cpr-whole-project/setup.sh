#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > payments.py <<'EOF'
def charge(order_id, amount_cents):
    if amount_cents <= 0:
        raise ValueError("amount must be positive")
    return {"order_id": order_id, "charged": amount_cents}
EOF
cat > orders.py <<'EOF'
from payments import charge


def complete(order):
    return charge(order["id"], order["total_cents"])
EOF
cat > refunds.py <<'EOF'
from payments import charge


def reverse_fee(order):
    # Fees are reversed by charging a negative amount.
    return charge(order["id"], -order["fee_cents"])
EOF
mkdir -p docs/plans
cat > docs/plans/refund-fees.md <<'EOF'
# Add a processing fee to every charge

1. In payments.py, change `charge` so it adds a 2% processing fee to the amount.
2. In orders.py, call `charge(order)` and let it read the total from the order.
3. Add tests for the fee in test_payments.py.
EOF
git add -A
git commit -qm 'Initial version'
