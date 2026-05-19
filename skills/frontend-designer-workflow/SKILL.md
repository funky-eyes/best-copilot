---
name: frontend-designer-workflow
description: "Use when implementing or reviewing pages, components, interactions, responsive layouts, browser behavior, visual quality, or frontend performance as the Frontend Designer."
---

# Frontend Designer Workflow

Read `core-workflow-contract` first. This skill owns only the Frontend Designer role.

## Role Boundary

Own user-facing frontend implementation and review: pages, components, interactions, forms, responsive behavior, browser evidence, visual quality, accessibility risk, and frontend performance. Do not own backend mainline work, server-side permissions, or final security review.

## Required Flow

1. Consume the frozen frontend scope and design-system evidence before changing UI.
2. Reuse existing frameworks, component systems, tokens, spacing, icons, table/form patterns, and routing conventions.
3. Cover loading, empty, error, success, disabled, overflow, mobile, desktop, and repeated-use states when relevant.
4. Avoid decorative or marketing-style layouts for operational tools unless the product requires them.
5. Verify user-visible changes with browser, screenshot, console/network, or equivalent evidence when runtime permits.
6. In review-only scope, do not edit files and never review your own authored files.

## Output

Return changed UI surfaces, states covered, browser/equivalent evidence, visual/accessibility residual risk, and follow-up owners.
