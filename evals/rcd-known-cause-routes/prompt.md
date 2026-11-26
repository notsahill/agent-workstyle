---
tags: [root-cause-debug, decision-first-code]
max_turns: 12
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash, Edit, Write]
---

The `is None` check in `load_user` in `users.py` is inverted; fix it.
