#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > signup.py <<'EOF'
def can_join_loyalty(user):
    return user["age"] >= 18 and user["country"] == "IN"
EOF
cat > checkout.py <<'EOF'
def apply_loyalty_discount(user, amount):
    if user["age"] >= 18 and user["country"] == "IN":
        return amount * 0.95
    return amount
EOF
cat > rewards.py <<'EOF'
def monthly_points(user, spend):
    eligible = user["age"] >= 18 and user["country"] == "IN"
    return int(spend // 100) if eligible else 0
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > signup.py <<'EOF'
def can_join_loyalty(user):
    return user["age"] >= 21 and user["country"] == "IN"
EOF
git add -A
git commit -qm 'Raise loyalty minimum age to 21'
