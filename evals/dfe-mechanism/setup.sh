#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > middleware.py <<'EOF'
import tokens


def authenticate(request, handler):
    header = request.get("headers", {}).get("Authorization", "")
    if not header.startswith("Bearer "):
        return {"status": 401}
    claims = tokens.verify(header[len("Bearer "):])
    if claims is None:
        return {"status": 401}
    request["user_id"] = claims["sub"]
    return handler(request)
EOF
cat > tokens.py <<'EOF'
import jwks_cache


def verify(token):
    key = jwks_cache.signing_key(token)
    if key is None:
        return None
    return {"sub": "user-from-" + token[:4]}
EOF
cat > jwks_cache.py <<'EOF'
import json
import time
import urllib.request

JWKS_URL = "https://idp.example.com/.well-known/jwks.json"
_cache = {"keys": None, "at": 0}


def signing_key(token):
    if _cache["keys"] is None or time.time() - _cache["at"] > 3600:
        _cache["keys"] = json.load(urllib.request.urlopen(JWKS_URL))["keys"]
        _cache["at"] = time.time()
    return _cache["keys"][0] if _cache["keys"] else None
EOF
git add -A
git commit -qm 'Initial version'
