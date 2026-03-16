---
id: RC-0016
title: Add mutation stress tests and harden invalid input paths
type: bug
status: done
value: 5
effort: 3
urgency: 5
risk: 2
score: 3.33
owner: dave
created: 2026-03-16
updated: 2026-03-16
completed: 2026-03-16
parent: null
depends_on: []
area: backlog
adr_refs: []
links: []
labels: [reliability, testing, input-validation]
---

## Why

Malformed or adversarial inputs currently crash the app instead of returning safe defaults or validation errors. This is a reliability risk for web form handling, simulation code, and core math paths.

## Outcome

All major input surfaces are stress tested with mangled values. Invalid input never causes an unhandled exception in request handling or simulation/projection entry points.

## Acceptance Criteria

- [x] Add mutation-style tests that pass malformed values across scenario parsing, allocation parsing, years/trials, and numerical fields.
- [x] Add request-level stress tests for the calculate endpoint that prove invalid form payloads are handled without 500 crashes.
- [x] Add lower-level tests for statistics/returns edge cases (empty arrays, NaN, Infinity, random boundary behavior).
- [x] Harden code paths so invalid or missing input is sanitized, bounded, and defaults safely.
- [x] Full spec suite passes with new tests.

## Notes

Primary crash vectors observed:

- `ScenarioBuilder#portfolio` currently calls `Portfolio.new` with invalid total weights and can raise `ArgumentError`.
- `ScenarioBuilder#years` can return negative values from malformed params.
- `Statistics#percentile` crashes on empty arrays (`nil.round`).
- `Statistics#gaussian` can produce `Math.log(0)` for random boundary values.
- Web request path currently does not rescue malformed scenario handling at boundary.

Stress strategy:

- Property-like mutation set for each numeric form field: `nil`, `""`, whitespace, alpha strings, scientific notation, huge magnitudes, `NaN`, `Infinity`, arrays, hashes.
- Allocation mutation set that forces sum < 1, sum > 1, negative/over-100 percentages.
- Years mutation set for negative, zero, huge, and non-numeric values.
- Monte Carlo/calculator mutation set for invalid scenario hashes to validate robust defaults.

## LLM Context

- Files likely affected: `lib/retirement/scenario_builder.rb`, `lib/retirement/statistics.rb`, `lib/retirement/web.rb`, and specs under `spec/retirement/` plus request specs.
- Invariants to preserve: Existing deterministic and Monte Carlo behavior for valid inputs; portfolio validation remains strict when directly constructed.
- Style constraints: Keep Ruby style and RSpec patterns consistent with current codebase.
- Known traps: Converting invalid values with `to_f` silently masks errors; avoid introducing NaN/Infinity into projections.
