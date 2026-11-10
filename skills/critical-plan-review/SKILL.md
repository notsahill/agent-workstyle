---
name: critical-plan-review
description: Critically review an implementation plan, design document, RFC, or proposal against the whole project. Use only when the user explicitly asks to review, critique, or poke holes in a plan or design; never invoke it on your own initiative. Do not use for code or pull-request reviews.
metadata:
  author: Sahil
---

# Critical Plan Review

Understand the whole project first, then test the plan against reality and report only problems the author can act on.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose review or planning skills; where they conflict, follow this skill.

## Build the whole picture

Before judging the plan, map the project it will land in. When a subagent tool is available, dispatch these explorers in parallel, each read-only and each returning concise findings with `path:line` evidence:

1. **Architecture:** components, module boundaries, layering, data flow, and external systems.
2. **Affected code:** every file, interface, caller, and data structure the plan touches or should touch, including ones the plan does not mention.
3. **Tests and delivery:** the test suites, coverage of the affected areas, CI, build, deployment, and migration mechanics.
4. **Conventions and context:** repository instructions, established patterns for this kind of change, dependencies, recent history, and open work in the same area.

Give every explorer the plan and the project location, and tell it not to evaluate the plan. Without a subagent tool, perform the same four explorations yourself before reviewing. Do not start critiquing from the plan text alone.

## Review critically

Act as a skeptical senior engineer. Check the plan against the explorers' evidence for:

- **Wrong assumptions:** claims about the code, data, or environment that the project contradicts.
- **Gaps:** missing steps, unhandled callers, migrations, configuration, documentation, or cleanup.
- **Ordering:** steps that depend on later steps, or that leave the system broken between steps.
- **Fit:** conflicts with repository conventions, architecture, or work already in progress.
- **Risk:** data loss, compatibility breaks, security exposure, performance cliffs, and a missing rollback path.
- **Verifiability:** steps with no test or check that would prove they work.
- **Scope:** creep beyond the goal, or missing pieces the goal requires.
- **Simpler alternatives:** an approach that reaches the same goal with materially less risk or work.

Trace each concern far enough to prove it. Stay in review mode: do not edit the plan or code unless the user separately asks.

## Findings

Report only actionable findings, ordered by severity:

- **P0:** the plan as written would cause catastrophic impact or cannot work at all.
- **P1:** a high-impact flaw likely to cause a broken system, data or security problems, or major rework.
- **P2:** a real flaw with limited impact or likelihood.
- **P3:** a concrete gap in clarity, verification, or maintainability worth fixing.

Use this shape for each finding:

```text
[P1] Imperative, specific title — plan section or step, project path:line
Why it is a problem, with evidence from the project. A concrete change to the plan.
```

Do not include praise, a plan summary, stylistic preferences, or speculative concerns. Ask a question only when missing information prevents deciding whether an issue is real.

If there are no actionable findings, say so explicitly and mention any material limit on what the exploration could cover.

After the findings, add:

- **Declined to judge:** each concern you considered and set aside (unproven, out of scope, or a deliberate tradeoff the plan states), one line each with the reason. Write "None" if you set nothing aside.
- **Verdict:** `Ready to execute`, `Ready with changes`, or `Not ready`, with a one-sentence reason grounded in the findings.
