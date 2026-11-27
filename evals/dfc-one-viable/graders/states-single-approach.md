---
type: llm
focus: last_message
---

The prompt fully specifies one change: pass `channel="email"` to notify.send in jobs/reminders.py, as the
other callers do. Pass if the final message does either of these:
(a) states that single change, says briefly why there is no real alternative, and asks for approval before editing; or
(b) reports that it made that change in jobs/reminders.py.
Fail only if it asks the user to choose between several options, or reports editing files other than
jobs/reminders.py. Verification notes, shipping notes, git commands, and "none found" sections do not matter.
