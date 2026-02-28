---
id: BL-0001
title: Set up retirement gem boilerplate
type: task
status: backlog
value: 5                   # foundational — everything depends on this
effort: 2                  # well-understood structure
urgency: 5                 # blocks all other work
risk: 1                    # standard gem layout, low surprise
score: 5.0                 # (5 + 5) / 2
owner: dave
created: 2026-02-28
updated: 2026-02-28
completed:
parent: null
depends_on: []
area: infrastructure
adr_refs: []
links: []
labels: [setup, gem]
---

## Why

Every subsequent ticket depends on having a working gem structure
with testing, linting, and examples in place. Without this, there
is no place to write or verify code.

## Outcome

A standard Ruby gem layout where `bundle exec rspec` runs green,
`bundle exec rubocop` passes clean, SimpleCov reports coverage,
and executable examples can be run from the command line.

## Acceptance Criteria

- [ ] Gem structure follows standard layout (lib/, spec/, exe/)
- [ ] `retirement.gemspec` with correct metadata
- [ ] `lib/retirement.rb` entry point with version constant
- [ ] `lib/retirement/version.rb` with `Retirement::VERSION`
- [ ] RSpec configured with `spec/spec_helper.rb`
- [ ] SimpleCov integrated and generating coverage reports
- [ ] RuboCop configured with `.rubocop.yml`
- [ ] `bundle exec rspec` passes
- [ ] `bundle exec rubocop` passes with no offenses
- [ ] At least one executable example in `exe/` that runs

## Notes

- Gemfile will be replaced with a stub: `gemspec` directive plus a
  dev/test group (rspec, rubocop, simplecov). Rails, sinatra, and
  rspec-rails are punted to BL-0002.
- Ruby 4.0.1 per `.ruby-version`, bundler 4.0.3 per `Gemfile.lock`.
- Keep the gemspec minimal; add runtime deps only as needed by later tickets.

## LLM Context

- Files likely affected: `retirement.gemspec`, `lib/retirement.rb`, `lib/retirement/version.rb`, `spec/spec_helper.rb`, `.rubocop.yml`, `exe/`, `Gemfile`, `Rakefile`
- Invariants to preserve: `.ruby-version` (4.0.1), `.ruby-gemset` (retirement)
- Style constraints: RuboCop defaults, adjust as needed
- Known traps: Gemfile vs gemspec dependency duplication — use `gemspec` directive in Gemfile
