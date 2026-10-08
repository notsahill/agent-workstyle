---
name: decision-first-code
description: Apply a decision-first work style when implementing, modifying, fixing, refactoring, or generating code. Use for coding tasks that may change repository files; do not use for read-only explanations or pull-request reviews.
metadata:
  author: Sahil
---

# Decision-First Code

Make implementation decisions with the user, then execute the selected approach precisely.

## Before editing

1. Read the applicable repository instructions and the code, tests, and configuration needed to understand the change.
2. Identify every viable, materially distinct choice that affects behavior, architecture, interfaces, data, dependencies, compatibility, test strategy, scope, or maintainability.
3. Identify the design approaches that would implement the change in line with sound design conventions, such as module boundaries, layering, composition versus inheritance, and error-handling, state, or data-access patterns. Always include the convention the repository already uses for this kind of change as the default option. If the repository has no established convention for it, say so and offer the best-practice option as the default.
4. Present those choices in a compact checkpoint. For each option:
   - explain the approach briefly;
   - list its pros and cons;
   - mark the existing repository convention as the default;
   - recommend one option and give the reason, explaining why it beats the default when it differs;
   - omit speculative, invalid, or repository-incompatible alternatives.
5. Ask the user to choose before editing, including which design approach to take. Bundle related choices instead of asking a stream of tiny questions.

If there is only one viable approach, state the proposed plan and why alternatives are not viable, then wait for approval. An approach already selected or an implementation plan already approved in the current conversation counts as approval; do not ask again.

Routine mechanical details do not need separate approval. A choice is nontrivial when a reasonable alternative would materially change the result or its tradeoffs.

## Implement

- Follow the selected approach and design approach. Where the user has not chosen otherwise, follow the repository's established conventions.
- Make the smallest coherent change that fully solves the request, including necessary tests and cleanup. Avoid unrelated refactors.
- If implementation reveals a new nontrivial choice, stop before committing to it, present the viable options with a recommendation, and wait for the user's decision.
- Do not silently broaden scope or substitute a different approach because it is easier.

## Verify and hand off

- Run the narrowest meaningful checks first, then expand verification in proportion to regression risk.
- Verify observable behavior where practical; do not treat compilation or static checks alone as proof of runtime behavior when the change requires more.
- Report the implemented behavior, the checks run and their outcomes, and anything that could not be verified.
