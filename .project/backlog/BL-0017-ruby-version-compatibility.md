---
id: BL-0017
title: Set Ruby version to Lambda-compatible 3.3
type: bug
status: backlog
value: 3                   # CI and Lambda both need this
effort: 1                  # change version constraint, test locally
urgency: 3                 # Lambda deploy forced a gemspec change already
risk: 2                    # Ruby 4.0 syntax may need adjusting
score: 6.0                 # (3 + 3) / 1
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: infrastructure
adr_refs: []
links: []
labels: [ruby, lambda, ci, compatibility]
---

## Why

The gemspec requires `ruby >= 4.0` but AWS Lambda's newest runtime is
Ruby 3.3. The constraint was relaxed to `>= 3.3` ad-hoc during Lambda
deploy work but needs a deliberate decision: pin to 3.3, support both,
or wait for Lambda to add 4.0.

## Outcome

Ruby version requirements are consistent across gemspec, `.ruby-version`,
CI workflow, and Lambda runtime. App runs cleanly on the chosen version.

## Acceptance Criteria

- [ ] Decide target Ruby version(s) and document rationale
- [ ] Update `.ruby-version` to match
- [ ] Update `retirement.gemspec` `required_ruby_version`
- [ ] Update CI workflow Ruby version matrix
- [ ] Verify `bundle exec rspec` passes on target version
- [ ] Verify Lambda deploy works on target version

## Notes

- Lambda supports Ruby 3.3 as of 2026-03. Ruby 3.4/4.0 not yet available.
- Local dev uses Ruby 4.0.1 via RVM — may need a gemset or version switch.
- Some Ruby 4.0 syntax may not be backward-compatible with 3.3.

## LLM Context

- Files likely affected: `.ruby-version`, `retirement.gemspec`, `.github/workflows/ci.yml`, `template.yaml`
- Invariants to preserve: local dev and Lambda deploy both work
- Style constraints: N/A
- Known traps: Ruby 4.0 may have breaking changes vs 3.3; native gems need matching platform
