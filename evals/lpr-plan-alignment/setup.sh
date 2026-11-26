#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > search.py <<'EOF'
PRODUCTS = ["red shoe", "blue shoe", "red hat"]
EOF
mkdir -p docs/plans
cat > docs/plans/search.md <<'EOF'
# Search plan

1. Add `search(term, limit=10)` returning products that contain `term`, case-insensitive, at most `limit` results.
2. Add tests for matching, case-insensitivity, and the limit.
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > search.py <<'EOF'
PRODUCTS = ["red shoe", "blue shoe", "red hat"]


def search(term):
    term = term.lower()
    return [p for p in PRODUCTS if term in p.lower()]
EOF
cat > test_search.py <<'EOF'
import unittest

from search import search


class SearchTest(unittest.TestCase):
    def test_match(self):
        self.assertEqual(search("red"), ["red shoe", "red hat"])

    def test_case(self):
        self.assertEqual(search("RED"), ["red shoe", "red hat"])


if __name__ == "__main__":
    unittest.main()
EOF
git add -A
git commit -qm 'Add product search'
