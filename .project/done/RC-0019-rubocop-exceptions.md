---
id: RC-0019
title: Add RuboCop exceptions to unblock CI
type: task
status: done
value: 3
effort: 1
urgency: 5
risk: 1
score: 8.0
owner: dave
created: 2026-04-13
updated: 2026-04-13
completed: 2026-04-13
parent: RC-0018
depends_on:
  - RC-0018
area: ci
adr_refs: []
links: []
labels:
  - ci
  - rubocop
  - tech-debt
---

## Why

CI fails on 23 RuboCop offenses after attestation pipeline added
`set -o pipefail`, which correctly propagates RuboCop's non-zero exit
through `tee`. These are pre-existing violations that need to be
suppressed to unblock the attestation pipeline.

## Outcome

CI passes cleanly. All existing offenses are suppressed via file-level
exclusions in `.rubocop.yml`, not code changes.

## Acceptance Criteria

- [ ] `bundle exec rubocop` reports zero offenses
- [ ] `bundle exec rspec` still passes
- [ ] No code changes — exceptions only in .rubocop.yml
- [ ] 3 auto-correctable PredicateMatcher offenses fixed in specs

## Notes

Exceptions added (to be cleaned up later):

- `Metrics/MethodLength` — database.rb
- `Metrics/ClassLength` — monte_carlo.rb, scenario_builder.rb
- `Metrics/ParameterLists` — scenario_builder.rb
- `Metrics/CyclomaticComplexity` — scenario_builder.rb
- `Metrics/PerceivedComplexity` — scenario_builder.rb
- `Metrics/AbcSize` — statistics.rb
- `Style/ComparableClamp` — statistics.rb
- `Gemspec/RequiredRubyVersion` — retirement.gemspec
- `RSpec/ExampleLength` — raised from 10 to 20
- `RSpec/MultipleExpectations` — raised from 1 to 8

## LLM Context

- Files likely affected: .rubocop.yml, spec/retirement/scenario_builder_spec.rb, spec/retirement/web_spec.rb
- Invariants to preserve: no production code changes
- Style constraints: file-level Exclude, not inline rubocop:disable
- Known traps: TargetRubyVersion 4.0 vs gemspec >= 3.3 mismatch is intentional (forward-looking)
