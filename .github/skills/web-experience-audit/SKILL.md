---
name: web-experience-audit
description: "Use after frontend page, component, style, route, form, or interaction changes to verify browser behavior and visual quality with real evidence."
---

# Web Experience Audit

## Checks

- Page loads without console errors relevant to the change.
- Primary workflow works.
- Desktop and mobile layouts fit without overlap or clipped controls.
- Loading, empty, error, and disabled states are coherent when applicable.
- Text is readable and does not overflow.
- Network calls match expected endpoints and do not leak sensitive data.

## Evidence

Use Playwright, browser tools, screenshots, console/network output, or the closest available runtime evidence. If browser verification is unavailable, state the blocker and provide static fallback checks.
