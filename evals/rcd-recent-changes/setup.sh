#!/bin/sh
# Builds this case's fixture repository in the eval workspace.
set -eu
git init -q -b main .
git config user.email dev@example.com
git config user.name Dev
cat > serializer.py <<'EOF'
import datetime


def to_row(record, date_format="%Y-%m-%d"):
    return [record["id"], record["date"].strftime(date_format)]


def from_row(row):
    return {"id": row[0], "date": datetime.datetime.strptime(row[1], "%Y-%m-%d")}
EOF
cat > export.py <<'EOF'
import csv
import sys

from serializer import to_row


def export(records, out=sys.stdout):
    w = csv.writer(out)
    for r in records:
        w.writerow(to_row(r))
EOF
cat > importer.py <<'EOF'
from serializer import from_row


def load(rows):
    return [from_row(r) for r in rows]
EOF
git add -A
git commit -qm 'Initial version'
cat > settings.py <<'EOF'
# Export date format; set per deployment.
EXPORT_DATE_FORMAT = None
EOF
cat > export.py <<'EOF'
import csv
import sys

import settings
from serializer import to_row


def export(records, out=sys.stdout):
    w = csv.writer(out)
    for r in records:
        w.writerow(to_row(r, date_format=settings.EXPORT_DATE_FORMAT))
EOF
git add -A
git commit -qm 'Make export date format configurable'
