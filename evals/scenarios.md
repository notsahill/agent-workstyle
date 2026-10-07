# Behavioral scenarios

These fixtures test decisions and observable invariants, not exact wording.

## `sahil-code`

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
- Recommends one option, justifying any departure from the default, and waits for Sahil to choose before editing.

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

## `sahil-pr-review`

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

