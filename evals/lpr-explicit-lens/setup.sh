#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > dedupe.py <<'EOF'
def unique_emails(rows):
    return list(dict.fromkeys(r["email"] for r in rows))
EOF
cat > nightly.py <<'EOF'
# Runs nightly over the full customer export (about 2 million rows).
from dedupe import unique_emails

def run(rows):
    return unique_emails(rows)
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > dedupe.py <<'EOF'
def unique_emails(rows):
    seen = []
    for r in rows:
        email = r["email"].strip().lower()
        if email not in seen:
            seen.append(email)
    return seen
EOF
git add -A
git commit -qm 'Normalise emails before de-duplicating'
