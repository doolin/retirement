---
id: RC-0009
title: Add asset class correlation and portfolio rebalancing
type: story
status: backlog
value: 3                   # improves simulation realism
effort: 4                  # correlation matrix, rebalancing logic
urgency: 1                 # advanced feature
risk: 3                    # correlation math is nuanced
score: 1.0                 # (3 + 1) / 4
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: financial-model
adr_refs: []
links: []
labels: [simulation, advanced]
---

## Why

The Monte Carlo simulation currently draws independent random returns
for each asset class. In reality, stocks and bonds are correlated
(often inversely). Ignoring correlation overstates diversification
benefit. Additionally, portfolios drift over time without rebalancing.

## Outcome

Asset returns are generated using a correlation matrix (Cholesky
decomposition), and portfolio weights are optionally rebalanced
annually back to target allocations.

## Acceptance Criteria

- [ ] Default correlation matrix for the 5 asset classes
- [ ] Correlated return generation via Cholesky decomposition
- [ ] Toggle for annual rebalancing (on/off)
- [ ] Rebalancing resets weights to target allocation each year
- [ ] Specs verify correlated returns differ from independent
- [ ] Specs verify rebalancing converges to target weights

## Notes

- Historical correlation approximations:
  Stocks/Bonds ~-0.2, Stocks/REITs ~0.6, Stocks/Intl ~0.8
- Cholesky decomposition of the correlation matrix transforms
  independent gaussian draws into correlated ones.
- Rebalancing has tax implications (see RC-0005) — ignore for now.

## LLM Context

- Files likely affected: new `correlation.rb`, `returns.rb`, `monte_carlo.rb`, `portfolio.rb`
- Invariants to preserve: uncorrelated mode still works as fallback
- Style constraints: strict RuboCop, extract matrix math into module
- Known traps: correlation matrix must be positive semi-definite
