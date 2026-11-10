---
name: reviewed-plan-execution
description: Execute an approved implementation plan task by task, with a fresh implementer subagent and an independent reviewer for each task, a bounded fix loop, and a final whole-branch review before shipping. Use when the user asks to execute, run, or implement an approved plan; do not use for writing or reviewing plans or for single-step changes.
metadata:
  author: Sahil
---

# Reviewed Plan Execution

Run an approved plan to completion: one fresh implementer per task, an independent review after each, a final whole-branch review, then ship.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose execution skills (for example subagent-driven-development, executing-plans, or finishing-a-development-branch); where they conflict, follow this skill.

You are the orchestrator. Decisions were settled with the user while planning (decision-first-plan, using the decision-first-code checkpoint), so execute without pausing between tasks or asking whether to continue. Keep your own context for coordination: hand subagents files, not pasted history, and never fix code yourself.

## Mid-run decisions

When execution surfaces a new choice the plan does not settle (a gap, a conflict between plan and code, an ambiguity, a reviewer finding the plan mandates), sort it:

- **Ask the user:** the choice changes a public interface, data or schema, dependencies, security, irreversible or destructive operations, or the plan's goal or scope. Stop, present the options with pros, cons, the convention default, and a recommendation, and wait.
- **Rule and continue:** anything smaller. Decide, using the plan's Goal, Decisions, and Global Constraints as the binding authority, and record it in the Execution Log as `Ruling: <decision> — <why> — <cost if wrong>`.

## Setup

1. Read the whole plan once. If it has a defect that blocks execution, sort it as a mid-run decision before starting.
2. If on the default branch, create a descriptively named feature branch.
3. Create a scratch directory outside the repository for task briefs, reports, and review packages.
4. Create a progress tracker with one item per task.

## Per task

### 1. Implement

- Record `BASE=$(git rev-parse HEAD)`.
- Extract the task's full text into a brief file in the scratch directory. Never make a subagent read the whole plan.
- Dispatch one fresh implementer subagent using [implementer-prompt.md](implementer-prompt.md), giving: one line on where the task fits; the brief path as its requirements; the interfaces and rulings from earlier tasks it needs; the plan's Global Constraints; and a report-file path. Do not paste the session's history or earlier tasks' summaries.
- Never run two implementers in parallel. Batch small same-shape edits (the same one-line change across files) into a single dispatch and review them as one unit.
- Record the implementer's identity so fix rounds can resume it.

### 2. Handle the report

- **DONE:** go to review.
- **DONE_WITH_CONCERNS:** read the concerns; resolve correctness or scope concerns before review, note observations and proceed.
- **NEEDS_CONTEXT:** supply the missing context and re-dispatch.
- **BLOCKED:** change something before retrying: more context, a more capable model, a smaller task, or a plan correction sorted as a mid-run decision. Never retry unchanged.
- **NEW_CHOICE:** sort it as a mid-run decision, then resume the implementer with the outcome.

### 3. Review

- Write a review package to the scratch directory: `git log --oneline BASE..HEAD`, `git diff --stat BASE..HEAD`, and `git diff -U10 BASE..HEAD`. Use the recorded BASE, never `HEAD~1`.
- Dispatch a fresh reviewer using [reviewer-prompt.md](reviewer-prompt.md) with the brief, the report file, the review package, and the Global Constraints copied verbatim. Do not tell the reviewer what not to flag.
- Never skip the review, and never accept a review missing the spec verdict or the overall verdict. The implementer's self-review does not replace it.
- Resolve every "cannot verify from diff" item yourself using the plan and cross-task context; a confirmed gap counts as a failed spec check.

### 4. Fix loop

The loop runs when the spec check fails or the review reports any Critical or Important issue. Minor issues never enter it; log them as `Task N: minor (deferred): <one line>` for the final review.

A round is one fix dispatch plus one scoped re-review. At most five rounds per task:

- **Rounds 1–3:** resume the original implementer with the open findings verbatim.
- **Rounds 4–5:** dispatch a fresh implementer on a more capable model with the brief, the report file, and the open findings, saying the task is now theirs and prior attempts are in the report.

Each round the implementer fixes, re-runs the covering tests, and appends to the report. The re-review covers only the fix diff (from the head the previous review saw) and marks each finding ADDRESSED or NOT ADDRESSED, plus any new Critical or Important breakage in that diff. Log `Task N: fix round R/5 (<addressed> addressed, <open> open)`.

**At the cap,** rule on each open finding:

- **Reviewer wrong or contestable, or real but nothing builds on it:** park it as `Task N: parked — <finding> — Ruling: <why> — <cost if wrong>`.
- **Real and load-bearing:** if it falls in the ask-the-user tier, stop and ask; otherwise rule on the smallest change that unblocks dependent work, log it, and carry it into the next task's dispatch.

Rule only at the cap; never dismiss a finding early to end a loop.

### 5. Complete the task

Check off the task's steps in the plan, append `Task N: complete (<base7>..<head7>, <review clean | K parked>)` to the Execution Log, and move on. Never start the next task while a Critical or Important issue is neither fixed nor parked with a ruling.

## Final review

- Write a whole-branch package from the merge base with the default branch and dispatch one reviewer on the most capable available model using [reviewer-prompt.md](reviewer-prompt.md) in whole-branch mode, pointing it at the plan and the Execution Log's deferred and parked entries.
- If it reports findings, dispatch one fix subagent with the complete list, then one scoped re-review. Rule on any residual findings as at the cap. There is no second fix wave.

## Ship and hand off

- Run the repository's full test suite, plus the build and lint checks its CI runs, on the final tree. If it fails, stop and report.
- Commit the updated plan and Execution Log, then ship through the decision-first-code pre-authorized flow: push the branch and open a pull request whose description covers the tasks, rulings, and verification.
- Delete the scratch directory.
- Hand off with a walkthrough per task (what changed, at `path:line`, and why), **Rulings I made** (every `Ruling:` line in order, with its cost if wrong), deferred Minor issues, verification results, and the pull request link.

## Without a subagent tool

Execute the tasks inline in order. After each task, review your own diff against [reviewer-prompt.md](reviewer-prompt.md) before moving on, applying the same fix loop, mid-run decision tiers, final review, and shipping rules.
