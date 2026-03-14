---
id: BL-0004
title: Add Social Security and pension income streams
type: story
status: backlog
value: 5                   # core retirement modeling feature
effort: 3                  # new income model with start year logic
urgency: 3                 # important for realistic projections
risk: 2                    # straightforward concept, some edge cases
score: 2.67                # (5 + 3) / 3
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: financial-model
adr_refs: []
links: []
labels: [income, retirement]
---

## Why

Most retirees rely on Social Security and/or pension income that begins
at a specific age. The current model only has a single flat annual income
that applies from year 1. Without deferred income streams, projections
are unrealistic.

## Outcome

Users can specify one or more income streams with a start year, amount,
and optional COLA (cost of living adjustment). The calculator and Monte
Carlo simulation apply these correctly.

## Acceptance Criteria

- [ ] Form fields for Social Security: start year, monthly benefit
- [ ] Form fields for pension: start year, annual amount, COLA rate
- [ ] Income streams only contribute after their start year
- [ ] Monte Carlo simulation respects deferred income timing
- [ ] Specs cover income starting mid-projection

## Notes

- Social Security has a max benefit that changes annually — for now,
  just let the user enter their expected amount.
- COLA is typically ~2-3% for Social Security.
- Consider supporting multiple income streams (e.g., two spouses).

## LLM Context

- Files likely affected: `scenario_builder.rb`, `monte_carlo.rb`, `calculator.rb`, `views/index.erb`, `views/results.erb`
- Invariants to preserve: existing scenario hash structure, backward compat with no income streams
- Style constraints: strict RuboCop, 8-line method max
- Known traps: off-by-one on start year
