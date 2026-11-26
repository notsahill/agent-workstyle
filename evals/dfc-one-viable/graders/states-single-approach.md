---
type: llm
focus: last_message
---

The final message states the single viable change (passing a channel to notify.send in jobs/reminders.py, in
line with how the other callers do it) and briefly says why alternatives are not useful. It either asks for
approval before editing, or, if it already made the edit, it does not ask the user to choose between options.
