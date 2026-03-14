---
id: BL-0015
title: Fix stale Gemfile.lock and CI Ruby version
type: bug
status: backlog
value: 3                   # CI won't work without this
effort: 1                  # bundle install + CI config tweak
urgency: 4                 # blocks CI pipeline
risk: 1                    # straightforward
score: 7.0                 # (3 + 4) / 1
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: infrastructure
adr_refs: []
links: []
labels: [bug, ci, dependencies]
---

## Why

New gems (rubocop-performance, rubocop-rspec, rubocop-rake, sequel,
sinatra, puma, sqlite3) were installed via `gem install` but never
captured in Gemfile.lock via `bundle install`. The CI workflow
references Ruby 4.0 which `setup-ruby` may not support.

## Outcome

Gemfile.lock is up to date with all dependencies, and CI workflow
uses a Ruby version that `setup-ruby` actually supports.

## Acceptance Criteria

- [ ] `bundle install` succeeds and updates Gemfile.lock
- [ ] All gems in Gemfile and gemspec are reflected in lockfile
- [ ] CI workflow uses a supported Ruby version (or matrix)
- [ ] `bundle exec rspec` and `bundle exec rubocop` work via bundler

## Notes

- The bundler version mismatch (4.0.3 in lockfile vs 4.0.6 installed)
  may need resolving.
- Ruby 4.0 may need to be changed to 3.3 in CI until setup-ruby supports it.
- Consider pinning bundler version in CI.

## LLM Context

- Files likely affected: `Gemfile.lock`, `.github/workflows/ci.yml`, `.github/workflows/codeql.yml`
- Invariants to preserve: local development still works
- Style constraints: N/A
- Known traps: bundler/CGI incompatibility seen during `bundle install`
