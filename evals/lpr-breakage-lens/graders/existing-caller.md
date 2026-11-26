---
type: llm
focus: last_message
---

The final message reports that changing the default of `include_inactive` in accounts.py makes the existing
billing job (jobs/billing.py), which relies on the default, start billing inactive accounts. The finding names
who is affected.
