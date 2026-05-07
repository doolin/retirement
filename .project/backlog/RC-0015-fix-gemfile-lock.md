---
id: RC-0015
title: Fix stale Gemfile.lock and CI Ruby version
type: bug
status: done
value: 3                   # CI won't work without this
effort: 1                  # bundle install + CI config tweak
urgency: 4                 # blocks CI pipeline
risk: 1                    # straightforward
score: 7.0                 # (3 + 4) / 1
owner: dave
created: 2026-03-14
updated: 2026-05-07
completed: 2026-05-07
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

## Resolution (2026-05-07)

Closed as superseded — work landed across two later tickets:

- **RC-0024** refreshed `Gemfile.lock` end-to-end via `bundle update`,
  picking up every gem in the gemspec/Gemfile within its declared range.
- **RC-0025** loosened `puma` to `~> 8.0` and locked to 8.0.1.
- `.github/workflows/ci.yml` already pins `ruby-version: "3.3"` and uses
  `bundler-cache: true`, so `bundle exec rspec` and `bundle exec rubocop`
  run cleanly in CI.

Acceptance criteria are satisfied transitively; no further work needed.

## LLM Context

- Files likely affected: `Gemfile.lock`, `.github/workflows/ci.yml`, `.github/workflows/codeql.yml`
- Invariants to preserve: local development still works
- Style constraints: N/A
- Known traps: bundler/CGI incompatibility seen during `bundle install`
