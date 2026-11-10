---
name: decision-first-code
description: Apply a decision-first work style when implementing, modifying, fixing, refactoring, or generating code. Use for coding tasks that may change repository files; do not use for read-only explanations, plan writing, plan reviews, executing an approved multi-task plan (use reviewed-plan-execution), or pull-request reviews. For bugs whose cause is not yet known, use root-cause-debug first.
metadata:
  author: Sahil
---

# Decision-First Code

Make implementation decisions with the user, then execute the selected approach precisely, test-first, and hand off a verified pull request.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose process skills (for example brainstorming, test-driven-development, executing-plans, or finishing-a-development-branch); where they conflict, follow this skill.

## Before editing

1. Read the applicable repository instructions and the code, tests, and configuration needed to understand the change.
2. Identify every viable, materially distinct choice that affects behavior, architecture, interfaces, data, dependencies, compatibility, test strategy, scope, or maintainability.
3. Identify the design approaches that would implement the change in line with sound design conventions, such as module boundaries, layering, composition versus inheritance, and error-handling, state, or data-access patterns. Always include the convention the repository already uses for this kind of change as the default option. If the repository has no established convention for it, say so and offer the best-practice option as the default.
4. Treat every new dependency (library, package, service, or tool) as a nontrivial choice, even when it looks obvious. Name it, why it is needed, and the no-new-dependency alternative.
5. Note issues in the code you will touch that fall outside the request, and sort them:
   - **Trivial:** small, obviously correct, low-risk fixes in touched code, such as a typo, a dead import, an unused variable, or a clearly wrong comment.
   - **Larger:** anything else, including behavior changes, refactors, issues outside touched code, or anything with a reasonable alternative.
6. Present a compact checkpoint containing:
   - The choices. For each option: explain the approach briefly; list its pros and cons; mark the existing repository convention as the default; recommend one option and give the reason, explaining why it beats the default when it differs. Omit speculative, invalid, or repository-incompatible alternatives.
   - **Planned trivial fixes:** each with its location and a one-line description, so the user sees them before they happen. These do not need separate approval; the user may veto any of them.
   - **Larger issues found:** each with its location, impact, and the options for handling it (fix in this change, separate follow-up, or leave as is). Ask what should be done with each.
7. Ask the user to choose before editing, including which design approach to take and what to do with each larger issue. Bundle related choices instead of asking a stream of tiny questions.

If there is only one viable approach, state the proposed plan and why alternatives are not viable, then wait for approval. An approach already selected or an implementation plan already approved in the current conversation counts as approval; do not ask again.

Routine mechanical details do not need separate approval. A choice is nontrivial when a reasonable alternative would materially change the result or its tradeoffs.

## Implement

- Work test-first for features and bug fixes: write or update a test that captures the intended behavior, run it and confirm it fails for the expected reason, then implement until it passes. When the change cannot be meaningfully tested first (pure configuration, documentation, or a repository with no test harness), say so at the checkpoint and propose the verification you will use instead.
- Follow the selected approach and design approach. Where the user has not chosen otherwise, follow the repository's established conventions.
- Make the smallest coherent change that fully solves the request, including necessary tests and cleanup. Avoid unrelated refactors.
- Apply the announced trivial fixes. If you find a new trivial issue while working, fix it and add it to the trivial-fix list in the hand-off.
- If you find a new larger issue while working, do not fix it. Add it to the larger-issue list; if it blocks the selected approach, stop and ask.
- If implementation reveals a new nontrivial choice, stop before committing to it, present the viable options with pros, cons, and a recommendation, and wait for the user's decision.
- Do not silently broaden scope or substitute a different approach because it is easier.

## Verify

- Run the narrowest meaningful checks first, then expand verification in proportion to regression risk.
- Verify observable behavior where practical; do not treat compilation or static checks alone as proof of runtime behavior when the change requires more.
- For each regression test that guards a fix, prove it catches the bug: once it passes, temporarily revert the fix, confirm the test fails, then restore the fix and confirm it passes again.
- Before shipping, run the repository's full test suite, plus the build and lint checks its CI runs, on the final tree. If the repository has no full suite, say so and name what was run instead.

## Ship

The user has pre-authorized this git flow once the change is verified; do not ask again:

1. If on the default branch, create a descriptively named feature branch before committing.
2. Commit in focused commits that follow the repository's commit conventions.
3. Push the branch and open a pull request whose description covers the change, the decisions made, the trivial fixes, and the verification performed.

Stop before shipping and report instead if verification failed (including the full suite), the repository has no remote, or the user said not to commit for this task. Never force-push, rewrite published history, or merge without an explicit request.

## Hand off

Report as a walkthrough of the change:

- **Changes:** for each meaningful change, the `path:line` location, what changed, and why.
- **Trivial fixes:** each fix applied, with location, kept separate from the main change.
- **Larger issues:** each issue found, with its location, impact, and the user's decision, or the question still pending.
- **Verification:** each check run with its outcome, and anything that could not be verified.
- **Shipped:** the branch, commits, and pull request link, or why shipping was skipped.
