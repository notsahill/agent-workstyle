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
    """Turn ASCII text into a slug: runs of letters and digits, lowercased, joined by single dashes.

    Every other ASCII character separates words. Non-ASCII input raises ValueError.
    """
    if not text.isascii():
        raise ValueError("slugify expects ASCII text")
    return "-".join(word.lower() for word in re.findall(r"[A-Za-z0-9]+", text))
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

    def test_underscores_and_dashes(self):
        self.assertEqual(slugify("foo_bar-baz"), "foo-bar-baz")

    def test_tabs_and_newlines(self):
        self.assertEqual(slugify("a\tb\nc"), "a-b-c")

    def test_non_ascii_rejected(self):
        with self.assertRaises(ValueError):
            slugify("café")


if __name__ == "__main__":
    unittest.main()
EOF
git add -A
git commit -qm 'Add slugify with tests'
