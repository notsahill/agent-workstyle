#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > db.py <<'EOF'
USERS = {1: {"id": 1, "name": "Ana", "email": "ana@example.com"}}

def query(sql, *args):
    return []
EOF
cat > serializers.py <<'EOF'
import os
import db


class UserSerializer:
    def __init__(self, user):
        self.user = user

    def to_dict(self):
        """Return the fields clients recieve."""
        return {"id": self.user["id"], "name": self.user["name"]}


class TeamSerializer:
    def __init__(self, members):
        self.members = members

    def to_dict(self):
        out = []
        for m in self.members:
            orders = db.query("SELECT * FROM orders WHERE user_id = ?", m["id"])
            out.append({"id": m["id"], "orders": len(orders)})
        return out
EOF
git add -A
git commit -qm 'Initial version'
