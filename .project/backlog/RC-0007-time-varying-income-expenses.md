---
id: RC-0007
title: Support time-varying income and expenses
type: story
status: backlog
value: 4                   # much more realistic projections
effort: 3                  # schedule data structure + UI
urgency: 2                 # nice to have for accuracy
risk: 2                    # clean concept, UI complexity
score: 2.0                 # (4 + 2) / 3
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: financial-model
adr_refs: []
links: []
labels: [income, expenses]
---

## Why

Income and expenses aren't flat over 30 years. Salary increases,
job changes, retirement (income drops to zero), and healthcare
costs (rise faster than inflation) all change the picture.

## Outcome

Users can define a schedule of income/expense changes by year
(e.g., "income drops to $0 at year 10" or "healthcare adds $500/yr
starting year 15").

## Acceptance Criteria

- [ ] Repeatable form rows for income changes: year, amount
- [ ] Repeatable form rows for expense changes: year, amount
- [ ] Calculator applies changes at the specified year
- [ ] Monte Carlo simulation respects the schedule
- [ ] Results chart shows income/expense lines changing over time
- [ ] Specs for schedule with multiple transitions

## Notes

- Start simple: a list of (year, new_amount) pairs.
- Healthcare inflation could be a separate rate (e.g., 5-6% vs 3% general).
- Consider a "retirement year" shortcut that zeroes income.

## LLM Context

- Files likely affected: `scenario_builder.rb`, `monte_carlo.rb`, `calculator.rb`, `views/index.erb`
- Invariants to preserve: flat income/expense still works as default
- Style constraints: strict RuboCop, keep methods small
- Known traps: schedule must be sorted by year, handle gaps
