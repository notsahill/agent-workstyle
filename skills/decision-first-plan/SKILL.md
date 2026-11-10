---
name: decision-first-plan
description: Plan larger or multi-step work before coding. Explore the project, present the key decisions with pros, cons, and a recommendation, wait for choices, then write a step-by-step implementation plan without editing code. Use when asked to plan, scope, or design a feature, migration, or refactor; do not use for reviewing an existing plan or for small single-step changes.
metadata:
  author: Sahil
---

# Decision-First Plan

Settle the decisions with the user first, then write a plan a capable engineer could execute without coming back with questions.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose planning skills (for example brainstorming or writing-plans); where they conflict, follow this skill.

## Understand

- Read the applicable repository instructions and the code, tests, configuration, and documentation the work touches.
- Identify the goal, the constraints, what is explicitly out of scope, and what success looks like. Ask only for what the project and the request cannot answer.
- Find how the repository already handles similar work; that convention is the default design.

## Decide

Present a compact checkpoint of every nontrivial decision the plan depends on, such as architecture, interfaces, data and schema changes, migration and compatibility strategy, rollout, new dependencies, and test strategy. For each option:

- explain the approach briefly;
- list its pros and cons;
- mark the existing repository convention as the default;
- recommend one option and give the reason, explaining why it beats the default when it differs.

Treat every new dependency as a nontrivial decision. List larger issues discovered in the area and ask whether each belongs in the plan. Bundle related decisions into one checkpoint and wait for the user's choices. Decisions already made in the current conversation count; do not ask again.

## Write the plan

- Record the decisions made, with their reasons, at the top.
- Break the work into ordered steps small enough to verify independently. For each step give the files involved, the change, the test to write first, and how to verify it.
- Call out dependencies between steps, risky steps, rollback points, and anything that needs the user's input later.
- Keep scope to what was decided; list out-of-scope follow-ups separately.
- Place the plan where the user or repository convention says. If neither says, present it in the conversation and ask whether to save it.

Do not edit product code while planning. When the plan is approved, implementation follows the decision-first-code work style.
