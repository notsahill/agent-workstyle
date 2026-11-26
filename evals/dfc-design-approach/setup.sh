#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
mkdir -p clients
cat > clients/__init__.py <<'EOF'

EOF
mkdir -p clients
cat > clients/decorators.py <<'EOF'
import functools
import socket

def with_timeout(seconds):
    def wrap(fn):
        @functools.wraps(fn)
        def inner(*args, **kwargs):
            socket.setdefaulttimeout(seconds)
            return fn(*args, **kwargs)
        return inner
    return wrap
EOF
mkdir -p clients
cat > clients/payments.py <<'EOF'
from clients.decorators import with_timeout

@with_timeout(5)
def charge(order_id, amount_cents):
    ...
EOF
mkdir -p clients
cat > clients/shipping.py <<'EOF'
from clients.decorators import with_timeout

@with_timeout(5)
def create_label(order_id):
    ...
EOF
mkdir -p clients
cat > clients/inventory.py <<'EOF'
import urllib.request

def reserve(sku, quantity):
    req = urllib.request.Request(f"http://inventory.internal/reserve/{sku}?q={quantity}", method="POST")
    return urllib.request.urlopen(req).read()
EOF
git add -A
git commit -qm 'Initial version'
