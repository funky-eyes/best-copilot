---
name: frontend-design-guardrails
description: "Use when page, component, form, table, dashboard, responsive layout, or UI review work needs product-quality implementation guardrails. DO NOT USE FOR: backend-only changes or scripts with no user-visible surface."
---

# Frontend Design Guardrails

## Goal

Build usable interfaces that match the target repository's existing UI system and can be verified reliably.

## Rules

- Prefer the repository's existing component library, theme tokens, layout primitives, icon set, routing, and state patterns.
- For operational tools, favor dense, calm, scannable layouts over marketing-style hero sections.
- Use semantic controls: buttons for commands, inputs for text, selects/menus for option sets, tabs for views, toggles for binary settings.
- Provide loading, empty, error, disabled, success, and partial states when the workflow needs them.
- Avoid magic pixel offsets, absolute-positioned main layouts, clipped text, overlapping controls, and layout shifts.
- Ensure controls have stable accessible labels or text so browser tests can locate them.
- For mobile and desktop, verify that text fits and primary actions remain reachable.

## Before Implementation

Freeze:

- target user and workflow
- existing UI library/patterns
- page structure
- critical states
- responsive breakpoints
- validation method

## Design System Packet

For non-trivial UI work, generate a small design-system packet before coding, inspired by UI UX Pro Max:

- `product_type`
- `style_direction`
- `color_tokens`
- `typography`
- `spacing`
- `components`
- `accessibility_rules`
- `anti_patterns`

Store this in the task plan or component notes only when useful; do not create a persistent design-system folder unless the user or spec asks for it.

## Before Completion

Run or request a browser/visual check through `web-experience-audit`, or state why runtime verification is unavailable and provide static fallback evidence.
