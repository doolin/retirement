---
id: RC-0024
title: Update dependencies within current gemspec ranges
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
depends_on: []
area: maintenance
adr_refs: []
links: []
labels: [dependencies]
---

## Why

Routine maintenance. Pulls in patches across rubocop, rack,
sequel, sqlite3, and a few transitives. Major bumps to `lamby`
(5 → 6) and `puma` (7 → 8) are gated by `~>` constraints in the
gemspec and are deliberately left for separate tickets.

## Outcome

`Gemfile.lock` updated; specs and rubocop green.

## Acceptance Criteria

- [ ] `bundle update` run inside the current gemspec ranges
- [ ] No gemspec changes (no major bumps)
- [ ] `rspec` passes
- [ ] `rubocop` passes

## Notes

- New rubocop minor (1.86) may surface new cops. Address in this
  PR only if the fixes are mechanical; otherwise file a follow-up.

## LLM Context

- Files likely affected: `Gemfile.lock`
- Invariants to preserve: gemspec constraints unchanged
- Style constraints: rubocop must remain clean
- Known traps: new rubocop cops; transitives like `diff-lcs 2.0`
  could surface failures
