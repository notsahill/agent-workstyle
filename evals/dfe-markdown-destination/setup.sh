#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
mkdir -p jobs
cat > jobs/__init__.py <<'EOF'

EOF
mkdir -p jobs
cat > jobs/retry.py <<'EOF'
MAX_ATTEMPTS = 5


def next_state(job, ok):
    if ok:
        return "succeeded"
    if job["attempts"] + 1 >= MAX_ATTEMPTS:
        return "dead"
    return "retry_wait"


def backoff_seconds(attempts):
    return min(2 ** attempts, 300)
EOF
mkdir -p docs
cat > docs/jobs.md <<'EOF'
# Jobs

Background jobs run from the `jobs` table.
EOF
git add -A
git commit -qm 'Initial version'
