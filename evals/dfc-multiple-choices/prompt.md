---
tags: [decision-first-code]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash]
---

Add caching to the `get_product` endpoint in `app/api.py`. Redis is already available, but an in-process cache is also possible.
