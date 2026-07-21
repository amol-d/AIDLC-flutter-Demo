---
name: planning
description: Produce a short implementation spec/ADR for a non-trivial request and get human approval before writing code. Use for large, ambiguous, or multi-feature PRDs/tickets before implementation.
---

# Plan-before-code

For non-trivial work, produce a plan and get it approved **before** implementing.
Small, unambiguous requests skip straight to `feature-development`.

## When to plan

Plan first when the request is large, ambiguous, spans multiple features, changes
architecture, or the API contract is unclear. In the GitHub loop this is signalled by the
**`needs-plan`** label on the issue; `codex.yml` then posts a plan and waits for the
**`plan-approved`** label before implementing.

## The plan (keep it short)

Post a spec/ADR covering:

1. **Goal** — the user-facing outcome, in one or two sentences.
2. **Approach** — the shape of the solution; note any decision with trade-offs (ADR-style).
3. **Slices** — entities, endpoints, use cases, DTOs/mappers, screens/blocs to add or change
   (map onto the clean-architecture layers).
4. **Files to touch** — concrete paths, following the `feature-development` recipe.
5. **Tests** — what to add at each layer (DTO wire-shape, use-case, bloc, widget).
6. **Risks / open questions** — anything needing a human decision.

Do **not** modify files while planning. Surface assumptions instead of guessing (encode
uncertain API shapes as tolerant parsing once implementing).

## Approval

A human reviews the plan and either requests changes or adds **`plan-approved`**. Only then
does implementation proceed, following [feature-development](../feature-development/SKILL.md)
and the [promotion gate](../deploy/SKILL.md).
