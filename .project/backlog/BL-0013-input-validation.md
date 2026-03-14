---
id: BL-0013
title: Add form input validation
type: bug
status: backlog
value: 4                   # prevents silent errors
effort: 1                  # simple checks + error display
urgency: 3                 # easy to enter invalid data now
risk: 1                    # straightforward
score: 7.0                 # (4 + 3) / 1
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: ui
adr_refs: []
links: []
labels: [bug, validation, ui]
---

## Why

The form currently accepts any input without validation. Asset
allocations don't enforce summing to 100%, negative savings are
accepted, and return rates above 100% cause nonsense results.

## Outcome

Form inputs are validated both client-side (JavaScript) and
server-side (Ruby). Errors are displayed inline.

## Acceptance Criteria

- [ ] Asset allocation percentages must sum to 100% (or all be 0)
- [ ] JavaScript live-updates the allocation total as user types
- [ ] Savings, income, expenses must be >= 0
- [ ] Return rate between 0 and 0.30
- [ ] Inflation rate between 0 and 0.20
- [ ] Drawdown percent between 0 and 0.20
- [ ] Server-side validation returns errors with form re-rendered
- [ ] Specs for ScenarioBuilder validation

## Notes

- Client-side JS is for UX, server-side is the real gate.
- Show allocation total dynamically (e.g., "Total: 85% — must be 100%").

## LLM Context

- Files likely affected: `scenario_builder.rb`, `web.rb`, `views/index.erb` (JS), new `views/error` partial
- Invariants to preserve: valid inputs still work without changes
- Style constraints: strict RuboCop
- Known traps: form re-render must preserve user's entered values
