#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > auth.py <<'EOF'
def require_admin(fn):
    def inner(request, *a, **kw):
        if not request.get("user", {}).get("is_admin"):
            return {"status": 403}
        return fn(request, *a, **kw)
    return inner
EOF
cat > routes.py <<'EOF'
from auth import require_admin
import store

ROUTES = {}

def route(path):
    def reg(fn):
        ROUTES[path] = fn
        return fn
    return reg

@route("DELETE /admin/users/<id>")
@require_admin
def delete_user(request, user_id):
    store.delete_user(user_id)
    return {"status": 204}
EOF
cat > store.py <<'EOF'
USERS = {}

def delete_user(user_id):
    USERS.pop(user_id, None)

def delete_all_users():
    USERS.clear()
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > routes.py <<'EOF'
from auth import require_admin
import store

ROUTES = {}

def route(path):
    def reg(fn):
        ROUTES[path] = fn
        return fn
    return reg

@route("DELETE /admin/users/<id>")
@require_admin
def delete_user(request, user_id):
    store.delete_user(user_id)
    return {"status": 204}

@route("DELETE /admin/users")
def delete_all_users(request):
    store.delete_all_users()
    return {"status": 204}
EOF
git add -A
git commit -qm 'Add bulk user delete'
