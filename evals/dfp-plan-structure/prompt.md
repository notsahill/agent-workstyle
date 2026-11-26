---
tags: [decision-first-plan]
max_turns: 25
timeout_seconds: 420
allowed_tools: [Skill, Read, Grep, Glob, Bash, Write]
---

Write the implementation plan for rate limiting the public API. Decisions are settled: a fixed-window counter in
the existing Redis, 100 requests per minute per API key, a 429 response with a Retry-After header, applied as
middleware in `api/middleware.py`. Save it to `docs/plans/2026-11-26-rate-limiting.md`.
