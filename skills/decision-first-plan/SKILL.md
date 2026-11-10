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
- Break the work into ordered steps small enough to verify independently. For each step give:
  - **Files:** exact paths to create or modify, with line ranges where known.
  - **Interfaces:** what the step consumes from earlier steps and produces for later ones, with exact names, parameters, and return types.
  - **Test first:** the test to write, with its key assertions.
  - **Change:** the decision the implementer cannot make alone; signatures and pinned values, not full bodies the signature and test already determine.
  - **Verify:** the command to run and the output that means it passed.
- Call out dependencies between steps, risky steps, rollback points, and anything that needs the user's input later.
- Keep scope to what was decided; list out-of-scope follow-ups separately.

## Self-check

Before presenting the plan, check it and fix what you find:

- **Coverage:** every requirement and decision maps to a step.
- **Consistency:** every name, signature, and type used in a later step matches where an earlier step defined it.
- **Decisiveness:** no step says only "handle edge cases", "add validation", or "TBD"; each lets the implementer write exactly one reasonable thing.
- **Proportion:** the plan is not longer than the code it describes; replace transcribed code with signatures and test assertions.
- Place the plan where the user or repository convention says. If neither says, present it in the conversation and ask whether to save it.

Do not edit product code while planning. When the plan is approved, implementation follows the decision-first-code work style.
