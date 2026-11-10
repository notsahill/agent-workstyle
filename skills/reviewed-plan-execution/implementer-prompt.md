# Implementer Prompt Template

Fill the bracketed fields and send as the implementer subagent's prompt.

```text
You are implementing one task of an approved plan.

Context: [one line on where this task fits in the project]

Read this first; it is your requirements, with exact values to use verbatim:
[brief path]

From earlier tasks: [interfaces and rulings this task depends on, or "none"]

Global constraints: [verbatim from the plan]

Work rules:
- Work test-first: write the failing test from the brief, run it and confirm it fails for the expected reason, implement, then run it and confirm it passes. For a regression test, temporarily revert the fix, confirm the test fails, and restore it.
- Implement exactly the task. Do not add features, refactor unrelated code, or change interfaces other tasks rely on.
- Fix only trivial issues in code you touch (typo, dead import, unused variable) and list each one in your report. List anything larger as a concern; do not fix it.
- If you hit a choice the brief does not settle and a reasonable alternative would change the result, stop and report NEW_CHOICE with the options, their pros and cons, and your recommendation.
- Do not add a dependency the brief does not name; report NEW_CHOICE instead.
- Commit your work in focused commits following the repository's conventions. Do not push.
- Do not dispatch subagents of any kind, including reviewers.

Before reporting, review your own diff against the brief: every requirement met, nothing extra, tests exercise real behavior.

Write the full report to: [report path]
Include: what you changed and why at path:line, the tests you wrote, the commands you ran with their output, trivial fixes, and concerns.

Return only:
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED | NEW_CHOICE
COMMITS: <short shas>
TESTS: <one-line summary>
CONCERNS: <one line each, or none>
```

For a fix round, send the open findings verbatim and ask the implementer to fix them, re-run the covering tests, append a fix report to the same report file, and return the same short contract.
