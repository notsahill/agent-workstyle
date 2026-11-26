#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > greet.py <<'EOF'
import logging

log = logging.getLogger(__name__)


def greeting(profile):
    log.info("greeting user")
    return "Hello, " + profile["first_name"]
EOF
cat > views.py <<'EOF'
from greet import greeting


def home(request):
    return greeting(request["profile"])
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > greet.py <<'EOF'
import logging

log = logging.getLogger(__name__)


def greeting(profile):
    log.info("building greeting")
    return "Hello, " + profile["first_name"]
EOF
git add -A
git commit -qm 'Clarify greeting log message'
