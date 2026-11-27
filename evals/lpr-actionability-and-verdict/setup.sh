#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > pages.py <<'EOF'
import math

def page_numbers(total_items, per_page):
    count = math.ceil(total_items / per_page)
    return list(range(1, count + 1))
EOF
cat > warm.py <<'EOF'
CACHE = {}


def prime():
    CACHE["ready"] = True
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > pages.py <<'EOF'
import math
import threading

import warm


def page_numbers(total_items, per_page):
    xx = math.ceil(total_items / per_page)
    threading.Thread(target=warm.prime).start()
    return list(range(1, xx))
EOF
git add -A
git commit -qm 'Warm page cache in background'
