---
id: BL-0002
title: Choose and set up web framework
type: spike
status: backlog
value: 4                   # needed for the web UI, core deliverable
effort: 3                  # framework choice + wiring + config
urgency: 2                 # not blocking until gem core exists
risk: 3                    # architectural decision with long-term impact
score: 2.0                 # (4 + 2) / 3
owner: dave
created: 2026-02-28
updated: 2026-02-28
completed:
parent: null
depends_on: [BL-0001]
area: infrastructure
adr_refs: []
links: []
labels: [setup, web, framework]
---

## Why

The retirement calculator is a web application. We need to pick a
framework (Rails, Sinatra, or both) and wire it into the gem
structure established by BL-0001.

## Outcome

A running web server with at least one route that returns a response,
integrated into the gem layout with appropriate test support.

## Acceptance Criteria

- [ ] Framework decision made and documented (ADR if warranted)
- [ ] Framework gems added to gemspec or Gemfile as appropriate
- [ ] Basic app skeleton with at least one route
- [ ] Test helper configured for request/integration specs
- [ ] `rspec-rails` added if Rails is chosen
- [ ] Server starts and responds to a health-check request

## Notes

- Rails 8.1.2 and Sinatra 4.2.1 were in the original Gemfile —
  both are options. Could also mount Sinatra inside Rails.
- The README specifies local-only, encrypted SQLite, S3 backups —
  framework choice should support these naturally.
- This is typed as a spike because the framework decision itself
  is the main deliverable. Implementation may spawn follow-up tasks.

## LLM Context

- Files likely affected: `Gemfile`, `retirement.gemspec`, `config/`, `app/`, `spec/`
- Invariants to preserve: gem structure from BL-0001, RSpec + SimpleCov + RuboCop setup
- Style constraints: match whatever conventions the chosen framework expects
- Known traps: Rails generators may overwrite gem boilerplate files — run with care
