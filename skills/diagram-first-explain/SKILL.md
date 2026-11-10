---
name: diagram-first-explain
description: Explain how code, a system, a flow, or a concept in the repository works, in as few tokens as possible, leading with a diagram or workflow and then expanding only on what was asked. Use for read-only "how does X work", "walk me through", "what does this do", or "explain" questions; do not use when the request will change files.
metadata:
  author: Sahil
---

# Diagram-First Explain

Show the mechanism first, then say only what the question needs.

This skill encodes the user's own work style. When it applies, it takes precedence over overlapping general-purpose explanation styles; where they conflict, follow this skill.

## Investigate

- Read the code that implements what is asked, not only its documentation. Trace the real flow: entry points, calls, data, state, and failure paths.
- Stay read-only.

## Shape the answer

1. **Diagram first.** Open with a diagram or workflow of the mechanism: components, the path data or control takes, states, and failure paths. Skip the diagram only when there is no mechanism to show (a single value, a one-line fact) and answer in one or two sentences instead.
2. **One-line takeaway.** State the single claim the diagram makes.
3. **Depth on what was asked.** Expand only the parts the question is about, with `path:line` references. Add detail in proportion to what the user needs to understand or act; omit background they did not ask for.
4. **Offer more.** If important related areas were left out, name them in one line instead of explaining them.

Prefer the fewest tokens that keep the answer correct and complete for the question. Do not pad, restate the diagram in prose, or summarize what you are about to say.

## Diagram conventions

Follow the `drawing-workflow-diagrams` conventions. If that skill is available, load it for anything beyond a chat diagram; otherwise apply these rules directly:

- **Draw mechanism, not inventory.** Nodes are steps and systems, not classes or files. Fold detail into a short qualifier.
- **Label every arrow** with a verb or payload (`INSERT`, `long-poll`, `{id, model}`). An unlabelled arrow says nothing.
- **Fixed encodings:**
  - solid node: a component the project owns
  - dashed node: an external or managed system
  - datastore node: a table, index, cache, or bucket
  - solid edge: the success or deterministic path
  - dashed edge: failure, retry, or redelivery
- **Group by owner** with one lane per service or process when more than one owner is involved.
- **Before/after:** draw the edge each design adds or removes, not two disconnected pictures.

Choose the format by where the answer lands:

| Destination | Format |
|---|---|
| Chat or terminal | Plain-text diagram in a fenced code block, using the ASCII encoding below |
| Markdown file | A `mermaid` fenced block |
| HTML page or Artifact | Hand-authored inline SVG per `drawing-workflow-diagrams` |

ASCII encoding for chat:

```text
+---------+    owned component        [( orders )]   datastore
: Stripe  :    external system (dotted)
--label-->     success path            ..retry..>     failure or retry path
```
