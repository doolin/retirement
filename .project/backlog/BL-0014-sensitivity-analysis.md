---
id: BL-0014
title: Add sensitivity analysis and ruin probability
type: story
status: backlog
value: 4                   # answers "will I run out of money?"
effort: 3                  # new analysis mode + visualization
urgency: 2                 # high value but not blocking
risk: 2                    # well-understood financial concept
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
labels: [analysis, visualization]
---

## Why

Users need to know: "What year do I run out of money?" and "How
sensitive is my plan to lower returns?" The current output shows
balances but doesn't highlight danger zones or answer these questions.

## Outcome

Results page shows ruin probability (% of MC trials that hit $0),
the year of ruin in the worst case, and a sensitivity table showing
outcomes under different return assumptions.

## Acceptance Criteria

- [ ] Ruin probability: % of Monte Carlo trials where balance <= 0
- [ ] "Ruin year" displayed for p10 scenario (worst 10%)
- [ ] Zero line on the Monte Carlo chart (visual danger zone)
- [ ] Sensitivity table: outcomes at -2%, -1%, base, +1%, +2% return
- [ ] Summary card: "X% chance of running out of money"
- [ ] Specs for ruin probability calculation

## Notes

- Ruin probability is simply: (trials where any year <= 0) / total trials.
- Sensitivity analysis: re-run MC with adjusted return rates.
- Consider coloring the chart red below $0.

## LLM Context

- Files likely affected: `monte_carlo.rb`, `views/results.erb`, new `sensitivity.rb`
- Invariants to preserve: existing percentile output unchanged
- Style constraints: strict RuboCop
- Known traps: running MC 5x for sensitivity is slow — consider fewer trials
