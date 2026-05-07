---
id: RC-0008
title: Start drawdown at retirement year, not year 1
type: bug
status: in_progress
value: 5                   # current behavior is incorrect
effort: 1                  # simple conditional on year
urgency: 4                 # produces misleading results now
risk: 1                    # straightforward fix
score: 9.0                 # (5 + 4) / 1
owner: dave
created: 2026-03-14
updated: 2026-05-07
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
  or pension kicks in (see RC-0004, RC-0007).
- The deterministic `Calculator` does not currently apply drawdown at
  all (it only applies `annual_income - annual_expenses`), so there is
  nothing to gate there. The Monte Carlo path is where drawdown is
  modeled and where this gate matters.

## Implementation (2026-05-07)

- Added `retirement_age` column (default 65) to the scenarios table.
- Added `retirement_age` to `ScenarioBuilder`, defaulting to 65 and
  clamped to [18, 120].
- Added `Drawdown#years_until_retirement` and
  `Drawdown#drawdown_for_year`, the latter returning 0.0 before the
  retirement year.
- `MonteCarlo#adjusted_drawdown` now calls the gated helper.
- Form gains a Retirement Age input; results summary shows
  "starts at age N, in M yr" when retirement is in the future.

## LLM Context

- Files likely affected: `drawdown.rb`, `monte_carlo.rb`, `scenario_builder.rb`, `views/index.erb`
- Invariants to preserve: drawdown math itself is correct, just needs year gate
- Style constraints: strict RuboCop
- Known traps: off-by-one on retirement year boundary
