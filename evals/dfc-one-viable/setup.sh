#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > notify.py <<'EOF'
def send(user_id, message, *, channel):
    if channel not in ("email", "sms", "push"):
        raise ValueError(channel)
    print(f"[{channel}] {user_id}: {message}")
EOF
cat > orders.py <<'EOF'
import notify

def confirm(user_id, order_id):
    notify.send(user_id, f"Order {order_id} confirmed", channel="email")
EOF
cat > billing.py <<'EOF'
import notify

def receipt(user_id, amount):
    notify.send(user_id, f"Paid {amount}", channel="email")
EOF
mkdir -p jobs
cat > jobs/__init__.py <<'EOF'

EOF
mkdir -p jobs
cat > jobs/reminders.py <<'EOF'
import notify

def remind(user_id):
    notify.send(user_id, "Your cart is waiting")
EOF
git add -A
git commit -qm 'Initial version'
