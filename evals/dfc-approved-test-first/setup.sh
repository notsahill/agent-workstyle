#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > cart.py <<'EOF'
from decimal import Decimal

def total(prices):
    return sum((Decimal(str(p)) for p in prices), Decimal("0"))
EOF
cat > test_cart.py <<'EOF'
import unittest
from decimal import Decimal

from cart import total

class TotalTest(unittest.TestCase):
    def test_sums_prices(self):
        self.assertEqual(total([1, 2]), Decimal("3"))

if __name__ == "__main__":
    unittest.main()
EOF
cat > README.md <<'EOF'
Run tests with `python3 -m unittest`.
EOF
git add -A
git commit -qm 'Initial version'
