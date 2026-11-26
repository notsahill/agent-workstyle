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

- **Correctness:** local defects: edge cases, null and empty values, missed branches, error handling, transactions, concurrency, and retries.
- **Breakage:** what fails first after merge and deploy: existing callers, jobs, and screens that get new behavior; old and new code running side by side; migrations and rows already stored; flag and config defaults; dependency failures that leave state half-written or stuck; silent wrong data; and who is affected.
- **Logic:** whether the code does what the PR, issue, or plan intends: rules that must agree across call sites, enum values and stored states the change forgets, order of operations, and tests that assert the wrong rule.
- **Contract:** what other consumers notice: API paths, request and response shapes, enums, schemas and migrations, events, jobs, and shared modules read by clients, other repositories, or rows already stored.
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
- Under breakage, logic, and contract, look past the diff: find the existing callers, other copies of changed rules, and consumers of changed interfaces, and compare them with the base branch.
- Compare suspected defects with the base branch. A defect that already exists there is not a finding for this change unless the change makes it reachable or wider; then report it and say it predates the change.
- Review the selected lens deeply. Also report a clear P0 or P1 defect outside that lens when ignoring it would expose users or the system to serious harm.
- Stay in review mode. Do not edit code, commit, approve, reject, or post comments unless the user separately asks for that action.

## Refute before reporting

Before reporting, try to disprove every drafted P0, P1, and P2 finding. P3 findings skip this pass. The pass is mandatory: running the code, a reproduction, or high confidence does not replace it.

- When a subagent tool is available, dispatch one fresh, read-only refuter per finding using [refute-prompt.md](refute-prompt.md). Give it the finding's severity, title, location, and one-sentence claim, the change and base branch, and the repository path. Do not give it the reasoning or evidence that produced the finding. Independent refuters may run in parallel.
- Without a subagent tool, refute each finding yourself as a separate pass: re-read the cited code, its callers, and the guards before it from scratch, looking only for what makes the claim false.
- Apply the verdict:
  - **Refuted:** move the finding to Declined to judge, citing the refuter's `path:line` evidence.
  - **Confirmed:** keep the finding. If the refuter says its size or cause is overstated, correct the finding, and its severity if needed.
  - **Unsure:** keep the finding at its severity and add a final line, `Unconfirmed: <what would settle it>`.
- Whenever any P0, P1, or P2 finding was drafted, report the pass after the findings as one line: `Refute pass: N checked — X confirmed, Y refuted, Z unsure`.

## Findings

Report only actionable findings, ordered by severity:

- **P0:** immediate catastrophic impact, such as broad data loss, severe security compromise, or production outage.
- **P1:** high-impact defect likely to affect users, security, data integrity, or a core workflow.
- **P2:** real defect with limited impact, reach, or likelihood.
- **P3:** concrete maintainability or test problem worth fixing under the selected lens.

Use this shape for each finding:

```text
[P1] Imperative, specific title — path/to/file:line   Proof: ran
Impact and the conditions that trigger it. Evidence from the changed code and relevant context. A concrete remediation.
```

Label each finding with its strongest proof:

- `ran`: observed by executing something (a test, a command, a reproduction).
- `read`: traced in the code.
- `doc`: stated by the plan, PR, issue, documentation, or the user, and not contradicted by the code.

A `guess` (not checked) is never a finding; it belongs under Declined to judge or in an `Unconfirmed:` line.

Keep locations as tight as possible and within the diff when the interface permits. Do not include praise, a change summary, stylistic preferences, or speculative concerns. Ask a question only when missing information prevents deciding whether an issue is real.

If there are no actionable findings under the chosen lens, say so explicitly and mention any material verification limitation.

After the findings, add the refute-pass line, then:

- **Declined to judge:** each concern you considered and set aside (unproven, out of lens, out of scope, intended behavior, or pre-existing on the base branch), one line each with the reason, so nothing is dropped silently. Write "None" if you set nothing aside.
- **Verdict:** `Ready to merge`, `Ready with fixes`, or `Not ready`, with a one-sentence reason grounded in the findings.
