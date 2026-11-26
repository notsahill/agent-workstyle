---
tags: [root-cause-debug]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash]
---

We have tried three fixes for the duplicate-charge bug in `payments.py`. Adding a lock broke refunds, moving the
check into the webhook made retries charge twice, and caching the payment id leaked charges between customers.
Each fix revealed a new problem somewhere else. What now?
