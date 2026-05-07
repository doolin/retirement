---
id: RC-0025
title: Bump puma 7 to 8
type: task
status: in_progress
value: 2
effort: 1
urgency: 2
risk: 2
score: null
owner: dave
created: 2026-04-16
updated: 2026-04-16
completed:
parent: null
depends_on: [RC-0024]
area: maintenance
adr_refs: []
links: []
labels: [dependencies, puma]
---

## Why

RC-0024 left puma at 7.x because the gemspec used `~> 7.0`.
Puma 8 brings keep-alive and persistent-timeout default changes
plus standard Ruby 3+ cleanups; nothing the app reads is
affected. Lambda boot uses Lamby, not Puma, so the production
path is untouched.

## Outcome

`puma ~> 8.0` in the gemspec, lock updated, local boot serves
the form and the calculate endpoint.

## Acceptance Criteria

- [ ] `retirement.gemspec` requires `puma ~> 8.0`
- [ ] `Gemfile.lock` shows puma 8.x
- [ ] `rspec` passes
- [ ] `rubocop` passes
- [ ] Local boot of `config.ru` returns 200 for GET /retirement
- [ ] POST /retirement/calculate returns 200 with after-tax columns

## Notes

- Puma 8 changes default `max_keep_alive` to 999 and
  `persistent_timeout` to 65s; we have no `puma.rb` so defaults
  apply. No custom hooks defined.
- Lambda packaging path doesn't include puma; only matters for
  local dev and `bin/retirement`.

## LLM Context

- Files likely affected: `retirement.gemspec`, `Gemfile.lock`
- Invariants to preserve: Lambda handler in `app.rb` keeps
  working; `config.ru` boots locally
- Style constraints: rubocop must remain clean
- Known traps: lowercase response headers (Sinatra emits
  spec-conformant headers, no impact)
