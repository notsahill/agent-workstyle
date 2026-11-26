---
tags: [decision-first-code]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash, Edit, Write]
---

`notify.send` now requires a keyword-only `channel` argument. Update the remaining caller in `jobs/reminders.py` to use `channel="email"`, as the other callers (which have already migrated) do.
