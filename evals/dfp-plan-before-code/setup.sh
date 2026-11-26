#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > poller.py <<'EOF'
import json
import time
import urllib.request

import orders


def poll_forever():
    while True:
        data = json.load(urllib.request.urlopen("https://partner.example/api/orders?since=last"))
        for o in data["orders"]:
            orders.upsert(o)
        time.sleep(30)
EOF
cat > orders.py <<'EOF'
STORE = {}


def upsert(order):
    STORE[order["id"]] = order
EOF
git add -A
git commit -qm 'Initial version'
