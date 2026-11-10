---
name: lens-pr-review
description: Review a pull request, branch, commit range, patch, or code diff with a user-selected review lens. Ask for the review lens first, inspect relevant context, and return only actionable findings; do not use for implementing fixes or for reviewing plans and designs.
metadata:
  author: Sahil
---

# Lens PR Review

Choose the review lens with the user before inspecting the change, then return only defects the author can act on.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose review skills; where they conflict, follow this skill.

## Choose the lens

If the request does not already select a lens, ask the user to choose one or describe a custom focus:

- **Correctness:** behavior, regressions, contracts, edge cases, error handling, concurrency, and compatibility.
- **Security:** trust boundaries, authorization, validation, injection, secrets, privacy, and unsafe defaults.
- **Performance:** algorithms, repeated work, I/O, allocation, contention, caching, and scale-sensitive paths.
- **Maintainability:** structure, clarity, coupling, API design, duplication, and future change cost.
- **Tests:** missing cases, weak assertions, false confidence, failure paths, and flaky or brittle coverage.
- **Comprehensive:** all of the above.
- **Custom:** the focus the user specifies.

Do not begin the review until the lens is known. A lens explicitly stated in the request counts as the selection.

## Inspect

- Read repository guidance, the full diff, the relevant surrounding code, and applicable tests or contracts.
- If the change implements a plan, spec, issue, or stated requirements, read them and check the diff against them. Missing planned work and unexplained deviations are findings under any lens.
- Trace enough of the affected flow to prove each finding; do not infer a defect from a changed line in isolation.
- Review the selected lens deeply. Also report a clear P0 or P1 defect outside that lens when ignoring it would expose users or the system to serious harm.
- Stay in review mode. Do not edit code, commit, approve, reject, or post comments unless the user separately asks for that action.

## Findings

Report only actionable findings, ordered by severity:

- **P0:** immediate catastrophic impact, such as broad data loss, severe security compromise, or production outage.
- **P1:** high-impact defect likely to affect users, security, data integrity, or a core workflow.
- **P2:** real defect with limited impact, reach, or likelihood.
- **P3:** concrete maintainability or test problem worth fixing under the selected lens.

Use this shape for each finding:

```text
[P1] Imperative, specific title — path/to/file:line
Impact and the conditions that trigger it. Evidence from the changed code and relevant context. A concrete remediation.
```

Keep locations as tight as possible and within the diff when the interface permits. Do not include praise, a change summary, stylistic preferences, or speculative concerns. Ask a question only when missing information prevents deciding whether an issue is real.

If there are no actionable findings under the chosen lens, say so explicitly and mention any material verification limitation.

After the findings, add:

- **Declined to judge:** each concern you considered and set aside (unproven, out of lens, out of scope, or intended behavior), one line each with the reason, so nothing is dropped silently. Write "None" if you set nothing aside.
- **Verdict:** `Ready to merge`, `Ready with fixes`, or `Not ready`, with a one-sentence reason grounded in the findings.
