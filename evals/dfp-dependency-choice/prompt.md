---
tags: [decision-first-plan]
max_turns: 20
timeout_seconds: 300
allowed_tools: [Skill, Read, Grep, Glob, Bash]
---

Plan sending weekly digest emails in the background. We could add a queue library such as Celery, or use the existing jobs table.
