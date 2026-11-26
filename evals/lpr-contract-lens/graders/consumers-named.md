---
type: llm
focus: last_message
---

The final message reports that renaming the `total` response field breaks its consumers (for example
clients/mobile_sync.py, which reads `total`), and that the new order status value is not handled by code that
switches on the status (clients/status_badge.py). Findings cite file:line locations.
