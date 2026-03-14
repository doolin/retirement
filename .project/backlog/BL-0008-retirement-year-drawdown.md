---
id: BL-0008
title: Start drawdown at retirement year, not year 1
type: bug
status: backlog
value: 5                   # current behavior is incorrect
effort: 1                  # simple conditional on year
urgency: 4                 # produces misleading results now
risk: 1                    # straightforward fix
score: 9.0                 # (5 + 4) / 1
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: financial-model
adr_refs: []
links: []
labels: [bug, drawdown]
---

## Why

Drawdown (retirement withdrawals) currently applies from year 1 of
the projection. In reality, drawdown should start at the user's
retirement year. Before retirement, the user is accumulating, not
withdrawing.

## Outcome

A "retirement year" input controls when drawdown begins. Before that
year, drawdown is zero. After, the configured percent/fixed applies.

## Acceptance Criteria

- [ ] Form input for retirement year (e.g., year 10 = retire in 10 years)
- [ ] Drawdown is zero before retirement year
- [ ] Drawdown applies from retirement year onward
- [ ] Monte Carlo respects retirement year
- [ ] Specs verify accumulation phase vs drawdown phase

## Notes

- High priority — this is a correctness issue, not a feature.
- Income should also drop to zero at retirement unless Social Security
  or pension kicks in (see BL-0004, BL-0007).

## LLM Context

- Files likely affected: `drawdown.rb`, `monte_carlo.rb`, `scenario_builder.rb`, `views/index.erb`
- Invariants to preserve: drawdown math itself is correct, just needs year gate
- Style constraints: strict RuboCop
- Known traps: off-by-one on retirement year boundary
