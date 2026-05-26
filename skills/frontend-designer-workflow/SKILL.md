---
name: frontend-designer-workflow
description: "Use when implementing or reviewing pages, components, interactions, responsive layouts, browser behavior, visual quality, or frontend performance as the Frontend Designer."
---

# Frontend Designer Workflow

Read `core-workflow-contract` first. This skill owns only the Frontend Designer role.

## Role Boundary

Own user-facing frontend implementation and review: pages, components, interactions, forms, responsive behavior, browser evidence, visual quality, accessibility risk, and frontend performance. Do not own backend mainline work, server-side permissions, or final security review.

## Required Flow

1. Consume the frozen PM dispatch packet (six-block format from `core-workflow-contract`), especially frontend scope and design-system evidence, before changing UI.
2. Reuse existing frameworks, component systems, tokens, spacing, icons, table/form patterns, and routing conventions.
3. Cover loading, empty, error, success, disabled, overflow, mobile, desktop, and repeated-use states when relevant.
4. Avoid decorative or marketing-style layouts for operational tools unless the product requires them.
5. Review frontend changes authored by Developer or Technical Architect when PM assigns that lane; focus on user-visible states, accessibility risk, browser behavior, and visual quality.
6. Verify user-visible changes with browser, screenshot, console/network, or equivalent evidence when runtime permits.
7. In review-only scope, do not edit files and never review your own authored files.

## Specialist Ask Boundary

Follow the Specialist Ask Boundary in `core-workflow-contract`. Do not ask users directly.

## Task-Type Routing

- `task_type=implementation`: own pages, components, interaction behavior, and browser-visible delivery within the frozen scope.
- `task_type=design_review`: assess user-visible states, visual hierarchy, interaction risks, and frontend portions of Technical Architect or Developer plans without editing files.
- `task_type=verification`: supply the frontend/browser verification lane for completed frontend work when PM/coordinator or QA needs browser-visible evidence; do not replace QA as the primary merge-readiness owner.

## Output

Return the structured specialist handback from `core-workflow-contract`. Within `artifacts`, include `changed_ui_surfaces`, `states_covered`, `experience_evidence`, and `browser_evidence`.
