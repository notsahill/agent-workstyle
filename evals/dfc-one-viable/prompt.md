---
tags: [decision-first-code]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash, Edit, Write]
---

`notify.send` now requires a keyword-only `channel` argument. Update the remaining caller in `jobs/reminders.py`; the other callers have already migrated.
