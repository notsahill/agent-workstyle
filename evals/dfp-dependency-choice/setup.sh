#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > jobs.py <<'EOF'
# Background jobs are rows in the `jobs` table, picked up by worker.py every 10 seconds.
import db


def enqueue(kind, payload, run_at=None):
    db.insert("jobs", {"kind": kind, "payload": payload, "run_at": run_at})
EOF
cat > worker.py <<'EOF'
import db

HANDLERS = {}


def tick():
    for job in db.due("jobs"):
        HANDLERS[job["kind"]](job["payload"])
EOF
cat > db.py <<'EOF'
def insert(table, row):
    ...


def due(table):
    return []
EOF
git add -A
git commit -qm 'Initial version'
