---
id: RC-0021
title: Add clubstraylight shamrock site link
type: task
status: in_progress
value: 2
effort: 1
urgency: 2
risk: 1
score: 4.0
owner: dave
created: 2026-04-13
updated: 2026-04-13
completed:
parent: null
depends_on: []
area: ui
adr_refs: []
links: []
labels:
  - ui
  - clubstraylight
---

## Why

All apps on clubstraylight.com should have a consistent, unobtrusive
link back to the main site.

## Outcome

A fixed-position shamrock + "clubstraylight.com" link appears in the
lower-right corner of every page.

## Acceptance Criteria

- [ ] Shamrock link renders on all pages via layout.erb
- [ ] Link points to https://clubstraylight.com
- [ ] Fixed position, bottom-right, fades up on hover
- [ ] Test verifies link text appears in response body

## Notes

- Uses Unicode shamrock U+2618 (&#9752;) colored green
- Inline styles per add-shamrock-link skill convention
- opacity 0.6 default, 1.0 on hover

## LLM Context

- Files likely affected: lib/retirement/views/layout.erb, spec/retirement/web_spec.rb
- Invariants to preserve: existing footer SHA display
- Style constraints: inline styles, not CSS classes
- Known traps: z-index must stay below modals (50)
