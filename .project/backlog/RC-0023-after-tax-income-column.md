---
id: RC-0023
title: Show after-tax income per year in deterministic table
type: task
status: in_progress
value: 3
effort: 1
urgency: 2
risk: 1
score: null
owner: dave
created: 2026-04-16
updated: 2026-04-16
completed:
parent: null
depends_on: [RC-0006]
area: financial-model
adr_refs: []
links: []
labels: [tax, income]
---

## Why

Gross annual income plus RMD is what the IRS taxes, but the user
sees neither the combined gross nor the after-tax take-home. A
flat effective tax rate is a stepping stone; bracket-aware
modeling lives in RC-0016.

## Outcome

Deterministic table shows, for each year, annual net income and
monthly net income computed from `(income + rmd) * (1 - tax_rate)`.

## Acceptance Criteria

- [ ] `tax_rate` input on the form (default 0.22, range 0.0-1.0)
- [ ] Deterministic table has `Net/yr` and `Net/mo` columns
- [ ] Net income = `(annual_income + rmd) * (1 - tax_rate)`
- [ ] Monthly net = yearly net / 12
- [ ] Income stays fixed year over year (no inflation escalation)
- [ ] Legend shows the tax rate
- [ ] Specs cover the calculation

## Notes

- Flat effective rate only. Brackets / filing status / state tax
  are out of scope and belong in RC-0016.
- RMD is zero before age 73, so net pre-73 is just
  `income * (1 - tax_rate)`.

## LLM Context

- Files likely affected: `scenario_builder.rb`, `web.rb`,
  `views/index.erb`, `views/results.erb`, spec files.
- Invariants to preserve: existing RMD chart and column keep
  working; deterministic balance projection unchanged.
- Style constraints: strict RuboCop, keep methods small.
- Known traps: tax_rate coerced into [0, 1]; divisor-by-zero
  not possible since 12 is a literal.
