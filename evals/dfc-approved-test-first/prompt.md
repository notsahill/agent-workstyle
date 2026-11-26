---
tags: [decision-first-code]
max_turns: 30
timeout_seconds: 480
allowed_tools: [Skill, Read, Grep, Glob, Bash, Edit, Write]
---

Earlier in this conversation we agreed on the approach: round `cart.total` to two decimals using
`Decimal.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)`. Implement it. There is no remote, so do not try to push.
