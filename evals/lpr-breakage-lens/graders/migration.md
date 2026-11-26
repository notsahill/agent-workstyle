---
type: llm
focus: last_message
---

The final message reports that the migration adds a NOT NULL column with no default, which fails or breaks on
rows already stored in the accounts table (or while old code still inserts rows without it).
