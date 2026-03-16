---
id: RC-0006
title: Implement required minimum distributions (RMDs)
type: story
status: backlog
value: 3                   # important for accuracy past age 73
effort: 2                  # table lookup + forced withdrawal
urgency: 1                 # only matters for older users
risk: 2                    # IRS tables are well-defined
score: 2.0                 # (3 + 1) / 2
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: [RC-0005]
area: financial-model
adr_refs: []
links: []
labels: [tax, withdrawal]
---

## Why

IRS requires minimum distributions from pre-tax retirement accounts
starting at age 73 (SECURE 2.0 Act). Ignoring RMDs underestimates
forced withdrawals and tax liability in later years.

## Outcome

When the user's age + projection year crosses the RMD threshold,
the calculator forces a minimum withdrawal from pre-tax accounts
based on the IRS Uniform Lifetime Table.

## Acceptance Criteria

- [ ] User inputs current age
- [ ] RMD calculation kicks in at age 73
- [ ] Uses IRS Uniform Lifetime Table divisors
- [ ] RMD is the floor — user's chosen drawdown applies if higher
- [ ] Specs verify RMD amounts at key ages (73, 80, 90)

## Notes

- Depends on RC-0005 for pre-tax account separation.
- Table divisors: age 73 = 26.5, age 80 = 20.2, age 90 = 12.2, etc.
- Roth accounts are exempt from RMDs (SECURE 2.0).

## LLM Context

- Files likely affected: new `rmd.rb`, `drawdown.rb`, `scenario_builder.rb`
- Invariants to preserve: drawdown logic, Roth exemption
- Style constraints: strict RuboCop
- Known traps: RMD age changed from 72 to 73 in 2023 — use current rules
