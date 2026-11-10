---
name: root-cause-debug
description: Debug a bug, failing test, crash, regression, or unexpected behavior whose cause is not yet known. Reproduce it, prove the root cause with evidence, present fix options with a recommendation, and wait for a decision before fixing. Do not use when the cause and fix are already known; use decision-first-code instead.
metadata:
  author: Sahil
---

# Root-Cause Debug

Find and prove why something is broken before changing anything, then let the user choose the fix.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose debugging skills (for example systematic-debugging); where they conflict, follow this skill.

## Reproduce

1. Read the applicable repository instructions, the report, and any logs, stack traces, or failing output.
2. Reproduce the failure with the smallest reliable trigger: a failing test, a command, or exact steps. Record the command and the observed versus expected output.
3. If it cannot be reproduced, say so, list what was tried, and ask for the missing information (environment, inputs, versions) instead of guessing at a fix.

## Find the root cause

- Trace the failing path from the symptom back to the earliest point where actual state diverges from expected state.
- Form hypotheses and test each one with evidence: a targeted log, assertion, debugger inspection, `git bisect`, or a minimal experiment. Discard hypotheses the evidence rejects.
- Distinguish the root cause from the symptom and from contributing factors. A fix at the symptom is not a root-cause fix.
- Investigation is read-only toward product code. Temporary instrumentation is allowed but must be removed before hand-off. Do not commit anything during investigation.

## Checkpoint

Stop and present:

- **Reproduction:** the trigger and the observed versus expected output.
- **Root cause:** what is wrong, at `path:line`, and the evidence that proves it.
- **Blast radius:** other callers, data, or behavior affected by the same cause.
- **Fix options:** each with a brief explanation, pros, and cons; mark the option that follows repository conventions as the default; recommend one and say why, explaining why it beats the default when it differs.
- **Larger issues found:** related problems outside the bug, each with its impact, asking what should be done with each.

Wait for the user's decision before fixing. If the root cause could not be proven, say so plainly, state the best-supported hypothesis and what evidence is missing, and ask how to proceed.

## Fix

After the user chooses, implement with the decision-first-code work style: start from a regression test that fails for the proven root cause, make the chosen fix, announce and apply trivial fixes, ask about larger issues, verify, ship through the pre-authorized git flow, and hand off with a change walkthrough. Confirm the original reproduction now passes.
