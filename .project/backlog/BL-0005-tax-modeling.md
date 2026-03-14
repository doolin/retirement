---
id: BL-0005
title: Add basic tax modeling for retirement accounts
type: story
status: backlog
value: 4                   # significantly improves accuracy
effort: 4                  # complex domain, multiple account types
urgency: 2                 # useful but not blocking
risk: 3                    # tax rules are complex, easy to oversimplify
score: 1.5                 # (4 + 2) / 4
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: financial-model
adr_refs: []
links: []
labels: [tax, accounts]
---

## Why

Pre-tax (401k/IRA) and post-tax (Roth) accounts have very different
withdrawal tax implications. Without tax modeling, projected balances
overstate actual spending power.

## Outcome

Users can split savings across account types (pre-tax, Roth, taxable),
and the calculator applies estimated effective tax rates to withdrawals.

## Acceptance Criteria

- [ ] Form inputs for pre-tax, Roth, and taxable account balances
- [ ] Configurable effective tax rate on pre-tax withdrawals
- [ ] Capital gains rate on taxable account withdrawals
- [ ] Roth withdrawals are tax-free
- [ ] Tax impact reflected in net withdrawal amounts
- [ ] Specs covering each account type

## Notes

- Start with a simple effective rate, not full bracket modeling.
- Could add bracket modeling as a future enhancement.
- RMDs (BL-0006) depend on this ticket's account type distinction.

## LLM Context

- Files likely affected: new `tax.rb` module, `scenario_builder.rb`, `monte_carlo.rb`, `views/`
- Invariants to preserve: single-account flow still works if no account types specified
- Style constraints: strict RuboCop
- Known traps: tax rules change frequently — keep it configurable, not hardcoded
