#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > slug.py <<'EOF'
def placeholder():
    return None
EOF
git add -A
git commit -qm 'Initial version'
git checkout -qb feature
cat > slug.py <<'EOF'
import re


def slugify(text):
    """Lowercase, keep ASCII letters and digits, join words with single dashes; other characters are dropped."""
    ascii_text = text.encode("ascii", "ignore").decode("ascii")
    words = re.findall(r"[a-z0-9]+", ascii_text.lower())
    return "-".join(words)
EOF
cat > test_slug.py <<'EOF'
import unittest

from slug import slugify


class SlugifyTest(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(slugify("Hello World"), "hello-world")

    def test_punctuation_and_spaces(self):
        self.assertEqual(slugify("  A,  B!!  c "), "a-b-c")

    def test_digits(self):
        self.assertEqual(slugify("Top 10 Tips"), "top-10-tips")

    def test_empty(self):
        self.assertEqual(slugify(""), "")

    def test_only_symbols(self):
        self.assertEqual(slugify("!!!"), "")

    def test_non_ascii_dropped(self):
        self.assertEqual(slugify("café au lait"), "caf-au-lait")


if __name__ == "__main__":
    unittest.main()
EOF
git add -A
git commit -qm 'Add slugify with tests'
