#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > accounts.py <<'EOF'
ACCOUNTS = [
    {"id": 1, "active": True},
    {"id": 2, "active": False},
]


def list_accounts(include_inactive=False):
    return [a for a in ACCOUNTS if include_inactive or a["active"]]
EOF
mkdir -p jobs
cat > jobs/__init__.py <<'EOF'

EOF
mkdir -p jobs
cat > jobs/billing.py <<'EOF'
from accounts import list_accounts


def run_monthly_billing(charge):
    for account in list_accounts():
        charge(account["id"])
EOF
mkdir -p migrations
cat > migrations/001_accounts.sql <<'EOF'
CREATE TABLE accounts (id INTEGER PRIMARY KEY, active BOOLEAN NOT NULL);
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > accounts.py <<'EOF'
ACCOUNTS = [
    {"id": 1, "active": True},
    {"id": 2, "active": False},
]


def list_accounts(include_inactive=True):
    """Admin screens need every account by default."""
    return [a for a in ACCOUNTS if include_inactive or a["active"]]
EOF
mkdir -p migrations
cat > migrations/002_account_region.sql <<'EOF'
ALTER TABLE accounts ADD COLUMN region TEXT NOT NULL;
EOF
git add -A
git commit -qm 'Show all accounts on admin screens and add region'
