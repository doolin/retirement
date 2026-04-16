---
id: RC-0016
title: Full tax-aware withdrawal strategy with account-level simulation
type: story
status: backlog
value: 5                   # transforms accuracy of projections
effort: 5                  # multi-account simulation, tax brackets, Roth conversion
urgency: 2                 # valuable but builds on RC-0006 RMD foundation
risk: 4                    # tax rules are complex, brackets change, state taxes vary
score: 1.4                 # (5 + 2) / 5
owner: dave
created: 2026-04-16
updated: 2026-04-16
completed:
parent: null
depends_on: [RC-0005, RC-0006]
area: financial-model
adr_refs: []
links: []
labels: [tax, accounts, withdrawal-strategy]
---

## Why

RC-0006 adds RMD display on the pre-tax portion, but treats withdrawals
as a single stream. In reality, retirees withdraw from pre-tax, Roth,
and taxable accounts in a tax-optimized order. Without modeling this,
projected spending power can be off by 20-30% due to unaccounted taxes.

## Outcome

Each account type (pre-tax, Roth, taxable) is simulated as a separate
balance that grows independently. Withdrawals follow a configurable
strategy (e.g., taxable-first, Roth-last) with federal tax brackets
applied to pre-tax withdrawals and capital gains rates to taxable.
RMDs from RC-0006 are enforced as a floor on pre-tax withdrawals.

## Acceptance Criteria

- [ ] Three separate balance tracks: pre-tax, Roth, taxable
- [ ] Each track grows at the portfolio/scenario return rate
- [ ] Configurable withdrawal order (e.g., taxable -> pre-tax -> Roth)
- [ ] Federal tax brackets applied to pre-tax withdrawals (2024 brackets as default)
- [ ] Long-term capital gains rate on taxable withdrawals
- [ ] Roth withdrawals are tax-free (qualified)
- [ ] RMD (from RC-0006) enforced as minimum pre-tax withdrawal at age 73+
- [ ] Optional Roth conversion modeling (convert X/yr from pre-tax to Roth)
- [ ] Net after-tax withdrawal displayed alongside gross withdrawal
- [ ] Monte Carlo simulation tracks all three balances per trial
- [ ] Results show effective tax rate per year
- [ ] Summary card for total lifetime taxes paid
- [ ] Chart showing balance breakdown by account type over time
- [ ] Specs for tax calculation, withdrawal ordering, and Roth conversion

## Design Notes

### Withdrawal Strategy Options
1. **Taxable First** — draw from taxable, then pre-tax, then Roth
2. **Pro-rata** — withdraw proportionally from all accounts
3. **Tax-bracket filling** — withdraw from pre-tax up to a bracket ceiling, then Roth

### Tax Modeling
- Start with 2024 federal brackets (single/married filing jointly)
- Effective rate on each pre-tax dollar withdrawn
- Standard deduction applied before bracket computation
- Capital gains: 0%/15%/20% based on total income
- State taxes: optional flat rate add-on (simplification)

### Roth Conversion Ladder
- User inputs annual conversion amount
- Conversion counts as taxable income in the conversion year
- Reduces future RMDs by shrinking the pre-tax balance
- Show break-even analysis: "conversion saves $X over projection"

### Monte Carlo Integration
- Each trial tracks three separate balances
- Withdrawal strategy applied per-year within each trial
- Percentile summary for total after-tax spending power

## Notes

- This is a significant refactor of the simulation engine
- Consider extracting an AccountManager class to handle multi-account logic
- Tax brackets should be stored as data (hash/array), not hardcoded logic
- Keep backward compatibility: if no account split provided, behave as today
- This subsumes RC-0005 (basic tax modeling)

## LLM Context

- Files likely affected: new `tax_brackets.rb`, new `withdrawal_strategy.rb`,
  major changes to `monte_carlo.rb`, `scenario_builder.rb`, `calculator.rb`,
  `views/index.erb`, `views/results.erb`
- Invariants to preserve: existing single-balance flow, RMD module, all current specs
- Style constraints: strict RuboCop (MethodLength 8, AbcSize 12, ClassLength 50)
- Known traps: method/class size limits will force aggressive extraction;
  tax bracket data as a hash constant to stay within line limits
