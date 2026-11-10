---
name: decision-first-plan
description: Plan larger or multi-step work before coding. Explore the project, settle every nontrivial decision with the user using the decision-first-code checkpoint, then write a structured, task-by-task implementation plan without editing code. Use when asked to plan, scope, or design a feature, migration, or refactor; do not use for reviewing an existing plan, executing a plan, or small single-step changes.
metadata:
  author: Sahil
---

# Decision-First Plan

Settle the decisions with the user first, then write a plan an engineer who has never seen this codebase could execute task by task without coming back with questions.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose planning skills (for example brainstorming or writing-plans); where they conflict, follow this skill.

## Understand

- Read the applicable repository instructions and the code, tests, configuration, and documentation the work touches.
- Identify the goal, the constraints, what is explicitly out of scope, and what success looks like. Ask only for what the project and the request cannot answer.
- Find how the repository already handles similar work; that convention is the default design.
- If the work spans several independent subsystems, propose splitting it into one plan per subsystem, each producing working, testable software on its own.

## Decide

Run the decision-first-code **Before editing** checkpoint, applied to the whole plan: present every nontrivial decision the plan depends on (architecture, interfaces, data and schema, migration and compatibility, rollout, new dependencies, test strategy) with a brief explanation, pros, cons, the existing repository convention marked as the default, and a recommendation; treat every new dependency as nontrivial; list planned trivial fixes and larger issues found in the area, asking what to do with each larger one.

Bundle related decisions into one checkpoint and wait for the user's choices. Decisions already made in the current conversation count; do not ask again. Do not write tasks until the decisions are settled.

## Map the files

Before writing tasks, list every file to create or modify and the one responsibility each has. Design units with clear boundaries and well-defined interfaces; files that change together live together. In an existing codebase, follow its established structure; split a file only when the plan already modifies it and it has become unwieldy.

## Size the tasks

A task is the smallest unit that carries its own test cycle and is worth an independent review. Fold setup, configuration, scaffolding, and documentation into the task whose deliverable needs them. Split only where a reviewer could reasonably reject one task while approving its neighbor. Every task ends with an independently testable deliverable.

Each step is one action with a checkable result: write the failing test; run it and see it fail; implement; run it and see it pass; commit.

## Write the plan

Save it to `docs/plans/YYYY-MM-DD-<feature>.md` unless the repository or the user specifies another location. Use this structure:

````markdown
# <Feature> Implementation Plan

> **For agentic workers:** execute with the reviewed-plan-execution skill. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** <one sentence>

**Architecture:** <two or three sentences on the approach>

**Tech Stack:** <key technologies and libraries>

**Decisions:** <each decision settled at the checkpoint, with its reason>

## Global Constraints

<Project-wide requirements every task must honor: version floors, dependency limits, naming and copy rules, compatibility and platform requirements. One line each, exact values verbatim.>

## Review Focus

<The up to five inputs or failure modes the requirements imply but no task's tests would otherwise exercise, most likely to bite a user first. One line each: the input or condition, and the behavior a reasonable user would expect. Add the test that pins each line to the task that owns the code.>

## Out of Scope

<Follow-ups deliberately excluded, including larger issues the user chose to defer.>

---

### Task N: <component>

**Files:**
- Create: `exact/path/new_file.ext`
- Modify: `exact/path/existing.ext:123-145`
- Test: `exact/path/test_file.ext`

**Interfaces:**
- Consumes: <exact names and signatures used from earlier tasks>
- Produces: <exact names, parameters, and return types later tasks rely on>

- [ ] **Step 1: Write the failing test** — test name and assertions as code, with exact values.
- [ ] **Step 2: Run it and confirm it fails** — command, and the expected failure.
- [ ] **Step 3: Implement `<signature>` in `<file>`** — one line on the approach when the signature and test leave a choice; a code block only for an algorithm they do not determine.
- [ ] **Step 4: Run it and confirm it passes** — command, and the expected output.
- [ ] **Step 5: Commit** — files to stage and the commit message.

## Execution Log

<Left empty; reviewed-plan-execution appends progress and rulings here.>
````

A step is done when the implementer can write exactly one reasonable thing from it. Give tests as code, signatures and pinned values for implementation, and the command plus expected output for verification. Refer to another task's Interfaces block instead of repeating its code. Never write lines that decide nothing, such as "TBD", "handle edge cases", or "add appropriate validation".

Do not edit product code while planning.

## Self-check

Before presenting the plan, check it and fix what you find inline:

- **Coverage:** every requirement and decision maps to a task.
- **Step scan:** every step lets the implementer write exactly one reasonable thing; no step transcribes a body its signature and tests already determine.
- **Consistency:** every name, signature, and type used in a later task matches where an earlier task defined it.
- **Review Focus:** each line has its test in the owning task; an empty section means you checked and found none.
- **Proportion:** the plan is not longer than the code it describes; replace transcribed code with signatures and test assertions.

## Hand off

Link the saved plan and ask the user to review it. Once approved, execution follows the reviewed-plan-execution skill.
