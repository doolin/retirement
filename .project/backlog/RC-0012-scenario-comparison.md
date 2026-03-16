---
id: RC-0012
title: Add scenario comparison view
type: story
status: backlog
value: 4                   # key decision-making feature
effort: 2                  # UI work, reuse existing projections
urgency: 2                 # useful once persistence exists
risk: 1                    # straightforward UI
score: 3.0                 # (4 + 2) / 2
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: [RC-0010]
area: ui
adr_refs: []
links: []
labels: [ui, comparison]
---

## Why

The whole point of a calculator is to compare options — "what if I
retire at 60 vs 65?" or "aggressive vs conservative portfolio?"
Currently there's no way to run two scenarios and see them side by side.

## Outcome

Users can select two or more saved scenarios and view their projections
overlaid on the same charts and tables.

## Acceptance Criteria

- [ ] Scenario list page with checkboxes for selection
- [ ] Compare button runs projections for selected scenarios
- [ ] Overlay line chart: multiple deterministic projections
- [ ] Overlay fan chart: Monte Carlo bands for each scenario
- [ ] Summary table comparing final balances and key metrics
- [ ] Works on mobile (scrollable)

## Notes

- Limit to 2-3 scenarios for readability.
- Color-code each scenario consistently across charts.
- Depends on RC-0010 for saved scenarios.

## LLM Context

- Files likely affected: new `views/compare.erb`, `web.rb` (compare route), Chart.js config
- Invariants to preserve: single-scenario flow unchanged
- Style constraints: strict RuboCop, mobile-friendly
- Known traps: Chart.js dataset colors must be distinct
