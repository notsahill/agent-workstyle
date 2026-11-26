---
tags: [decision-first-code]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash]
---

Add retry handling to `clients/inventory.py`. Other clients are wrapped with a decorator, but a base-class or middleware design would also work.
