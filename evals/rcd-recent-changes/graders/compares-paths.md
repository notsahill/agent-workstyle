---
type: llm
focus: last_message
---

The final message points to the recent commit that makes export pass a configurable date format
(settings.EXPORT_DATE_FORMAT, which is None) to the serializer, compares the failing export path with the working import path and names the difference, and asks
before fixing.
