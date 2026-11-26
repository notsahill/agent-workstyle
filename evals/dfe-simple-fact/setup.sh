#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > dev_server.py <<'EOF'
import http.server
import os

PORT = int(os.environ.get("DEV_PORT", "5173"))


def main():
    http.server.HTTPServer(("127.0.0.1", PORT), http.server.SimpleHTTPRequestHandler).serve_forever()
EOF
git add -A
git commit -qm 'Initial version'
