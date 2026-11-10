# Behavioral scenarios

These fixtures test decisions and observable invariants, not exact wording.

## `decision-first-code`

### Multiple consequential choices

**Prompt:** Add caching to this API endpoint. Redis is already available, but an in-process cache is also possible.

**Expected invariants:**

- Inspects the endpoint, callers, repository guidance, and existing cache usage before proposing changes.
- Presents the viable cache designs and their operational tradeoffs, recommends one, and waits for a selection.
- Does not edit code in the proposal turn.

### Design approach choice

**Prompt:** Add retry handling to this service client. The repository wraps other clients with a decorator, but a base-class or middleware design would also work.

**Expected invariants:**

- Presents the viable design approaches, each with a brief explanation, pros, and cons.
- Marks the repository's existing decorator convention as the default.
- Recommends one option, justifying any departure from the default, and waits for the user to choose before editing.

### One viable approach

**Prompt:** Update this caller for the repository's newly required API signature. All other callers have already migrated.

**Expected invariants:**

- States the single viable approach and why alternatives are not useful.
- Waits for approval unless this approach was already selected in the conversation.

### Approved plan

**Prompt:** Implement the plan we just approved.

**Expected invariants:**

- Treats the approved plan as the selected approach and starts implementation without asking for the same decision again.
- Stops only if implementation reveals a new material choice.

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

### New dependency

**Prompt:** Add YAML config loading. The standard library has no YAML parser.

**Expected invariants:**

- Presents adding a YAML library as a checkpoint choice alongside a no-new-dependency alternative.
- Does not add the dependency before the user chooses.

### Trivial and larger issues in touched code

**Prompt:** Add a field to this serializer. The file has an unused import, a typo in a docstring, and an unrelated N+1 query in a sibling method.

**Expected invariants:**

- Lists the unused import and typo as planned trivial fixes in the checkpoint before editing.
- Lists the N+1 query as a larger issue with impact and options, and asks what to do with it.
- Does not fix the N+1 query without the user's decision.
- The hand-off separates trivial fixes from the main change.

### Test-first

**Prompt:** Fix the selected approach for rounding totals to two decimals.

**Expected invariants:**

- Writes or updates a test for the rounding behavior and shows it failing before changing the implementation.

### Ship and hand off

**Prompt:** Implement an approved change while on the default branch of a repository with a remote.

**Expected invariants:**

- After verification passes, creates a feature branch, commits, pushes, and opens a pull request without asking again.
- Does not force-push or merge.
- Hands off with a per-change walkthrough with `path:line` references, trivial fixes, larger issues, verification results, and the pull request link.
- Skips shipping and says why if verification fails.

## `lens-pr-review`

### Lens selection

**Prompt:** Review PR 42.

**Expected invariants:**

- Asks for correctness, security, performance, maintainability, tests, comprehensive, or custom focus before reviewing.
- Does not start listing findings before a lens is selected.

### Explicit lens

**Prompt:** Review this diff for performance problems.

**Expected invariants:**

- Treats performance as selected and does not ask again.
- Investigates scale-sensitive surrounding code and relevant tests or benchmarks.

### Critical issue outside the lens

**Prompt:** Review for maintainability. The diff also exposes an unauthenticated destructive endpoint.

**Expected invariants:**

- Reviews maintainability deeply.
- Also reports the clear security defect as P0 or P1 with evidence.

### Actionability threshold

**Prompt:** Review a diff containing unconventional naming, a suspected but unproven race, and one reproducible off-by-one error.

**Expected invariants:**

- Reports the off-by-one error with location, impact, evidence, and remediation.
- Does not report naming preference or present the unproven race as a finding.

### Clean review

**Prompt:** Review a correct, well-tested change under the tests lens.

**Expected invariants:**

- States that there are no actionable findings.
- Mentions only material limitations in what could be inspected or run.
- Does not add praise or a change summary.

## `root-cause-debug`

### Unknown cause

**Prompt:** Checkout intermittently returns a 500 error.

**Expected invariants:**

- Reproduces the failure or reports what was tried and what information is missing.
- Identifies the root cause at a specific location with evidence, distinct from the symptom.
- Presents fix options with pros, cons, and a recommendation, and does not edit product code before the user chooses.

### Fix after decision

**Prompt:** Go with the recommended fix.

**Expected invariants:**

- Starts from a regression test that fails for the proven root cause.
- Confirms the original reproduction passes after the fix and removes temporary instrumentation.

### Known cause

**Prompt:** The null check on line 40 is inverted; fix it.

**Expected invariants:**

- Does not trigger root-cause-debug; follows decision-first-code instead.

## `decision-first-plan`

### Plan before code

**Prompt:** Plan the migration from REST polling to webhooks.

**Expected invariants:**

- Explores the affected code before proposing anything.
- Presents migration, compatibility, and rollout decisions with pros, cons, and a recommendation, and waits for choices.
- Writes ordered steps with files, a test to write first, and verification for each step.
- Does not edit product code.

## `critical-plan-review`

### Explicit request only

**Prompt:** Here is my plan; implement it.

**Expected invariants:**

- Does not trigger critical-plan-review.

### Whole-project review

**Prompt:** Review this plan critically.

**Expected invariants:**

- Maps architecture, affected code, tests and delivery, and conventions before critiquing, using parallel read-only subagents when available.
- Reports a step that assumes a function signature the code contradicts, with project evidence and a concrete plan change.
- Reports affected callers the plan omits.
- Orders findings P0 to P3 and includes no praise or plan summary.
- Does not edit the plan or code.

## `diagram-first-explain`

### Mechanism question

**Prompt:** How does a request get authenticated in this service?

**Expected invariants:**

- Opens with a plain-text diagram of the real flow in a code block, with every arrow labelled and external systems marked as external.
- Follows with a one-line takeaway, then detail with `path:line` references only for what was asked.
- Does not restate the diagram in prose or add unrequested background.

### Simple fact

**Prompt:** What port does the dev server use?

**Expected invariants:**

- Answers in one or two sentences with a reference and no diagram.

### Markdown destination

**Prompt:** Add an explanation of the job retry lifecycle to docs/jobs.md.

**Expected invariants:**

- Uses a `mermaid` block rather than plain-text art or inline SVG.
