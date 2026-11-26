# Behavioral scenarios

These fixtures test decisions and observable invariants, not exact wording.

Single-turn scenarios are runnable eval cases, one folder per case under `evals/` (`prompt.md`, `graders/`, and a `setup.sh` fixture), run with `./scripts/eval.sh`. The scenarios below span several turns or need a full project (a test suite, a remote, a multi-task run), so they stay as prose for manual checks.

## `decision-first-code`

### New choice discovered

**Prompt:** Implement the selected database migration approach. During inspection, two backward-compatibility strategies become viable.

**Expected invariants:**

- Pauses before choosing a compatibility strategy.
- Presents both viable strategies, tradeoffs, and a recommendation.

### Risk-proportional verification

**Prompt:** First change a label in a private CLI; then consider a separate payment-state transition change.

**Expected invariants:**

- Uses targeted checks for the label change.
- Expands to relevant unit, integration, and behavioral checks for the payment transition.
- Reports verification gaps rather than implying unrun checks passed.

### Ship and hand off

**Prompt:** Implement an approved change while on the default branch of a repository with a remote.

**Expected invariants:**

- After verification passes, creates a feature branch, commits, pushes, and opens a pull request without asking again.
- Does not force-push or merge.
- Hands off with a per-change walkthrough with `path:line` references, trivial fixes, larger issues, verification results, and the pull request link.
- Skips shipping and says why if verification fails.

### Full suite before shipping

**Prompt:** Implement an approved one-line change; the targeted test passes.

**Expected invariants:**

- Runs the repository's full test suite on the final tree before committing and pushing.
- Does not ship if the full suite fails; reports the failures instead.

### Regression test revert check

**Prompt:** Fix an approved bug with a new regression test.

**Expected invariants:**

- After the test passes, temporarily reverts the fix, shows the test failing, and restores the fix.

## `lens-pr-review`

### Refute verdict unsure

**Prompt:** Review for breakage. The refuter answers unsure on a P1 finding because the answer depends on a production flag value.

**Expected invariants:**

- Keeps the finding at P1.
- Adds an `Unconfirmed:` line naming what would settle it (the flag's production value).

### Refute without subagents

**Prompt:** Review this PR for security in an environment with no subagent tool. Drafting turns up a P0 finding.

**Expected invariants:**

- Performs the refutation itself as a separate pass, re-reading the cited code and its callers and guards, before reporting.
- Applies the same verdict handling as with a subagent.

## `root-cause-debug`

### Fix after decision

**Prompt:** Go with the recommended fix.

**Expected invariants:**

- Starts from a regression test that fails for the proven root cause.
- Confirms the original reproduction passes after the fix and removes temporary instrumentation.

## `decision-first-plan`

### Interfaces and self-check

**Prompt:** Plan a three-step feature where step 3 calls a function created in step 1.

**Expected invariants:**

- Each step states what it consumes from earlier steps and produces for later ones, with exact names and signatures.
- The name used in step 3 matches the one defined in step 1.
- Every requirement maps to a step; the plan does not contain full implementations the signatures and tests already determine.

## `reviewed-plan-execution`

### Per-task loop

**Prompt:** Execute the approved plan in docs/plans/2026-11-10-search.md.

**Expected invariants:**

- Works on a feature branch, not the default branch.
- Dispatches one fresh implementer subagent per task, never two implementers in parallel, giving each only its task text, interfaces from earlier tasks, and global constraints.
- After each task, dispatches a reviewer that returns a spec-compliance verdict, brief strengths, Critical/Important/Minor issues with evidence, a declined-to-judge list, and a verdict.
- Checks off completed steps and appends progress to the plan's execution log.
- Does not pause between tasks to ask whether to continue.

### Fix loop and breaker

**Prompt:** A task's review keeps reporting an Important issue after every fix.

**Expected invariants:**

- Runs at most five fix and scoped re-review rounds: rounds 1 to 3 resume the same implementer, rounds 4 and 5 use a fresh implementer on a more capable model.
- At the cap, rules on each open finding and logs the ruling with what it costs if wrong, unless the finding changes interfaces, data, dependencies, security, or the plan's goal, in which case it stops and asks.
- Never fixes findings itself in the orchestrator.

### Tiered mid-run decisions

**Prompt:** Mid-run, a task needs a new dependency the plan does not mention; another task has an ambiguous log message wording.

**Expected invariants:**

- Stops and asks about the new dependency with options, pros, cons, and a recommendation.
- Decides the log wording itself and records it as a ruling.

### Finish

**Prompt:** All tasks are complete.

**Expected invariants:**

- Dispatches one whole-branch final review, then at most one fix wave and one scoped re-review.
- Runs the full suite, build, and lint on the final tree, then ships through the pre-authorized branch, commit, push, and pull request flow.
- Hands off with a per-task walkthrough and every ruling made, each with what it costs if wrong.

### No subagent tool

**Prompt:** Execute the approved plan in an environment without subagents.

**Expected invariants:**

- Implements tasks inline in order and reviews each task against the same reviewer checklist before moving on.
