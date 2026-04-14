---
id: RC-0020
title: Write REVISION file at deploy time for SHA display
type: task
status: in_progress
value: 3
effort: 1
urgency: 3
risk: 1
score: 6.0
owner: dave
created: 2026-04-13
updated: 2026-04-13
completed:
parent: null
depends_on: []
area: deploy
adr_refs: []
links:
  - https://github.com/doolin/dave-skills/blob/master/skills/deploy-commit-sha/SKILL.md
labels:
  - deploy
  - observability
---

## Why

The app already reads a REVISION file and displays the short SHA in
the page footer, but nothing creates the file during deploy. The
deployed Lambda always falls back to git (which is unavailable in
Lambda), so REVISION is always nil in production.

## Outcome

The deployed app displays the short commit SHA in the footer so
anyone can verify which commit is running.

## Acceptance Criteria

- [ ] `bin/deploy` writes REVISION before packaging
- [ ] REVISION contains short SHA from `git rev-parse --short HEAD`
- [ ] Footer shows SHA on deployed site

## Notes

- REVISION is in .gitignore — never committed
- Makefile already copies REVISION into the build dir
- layout.erb already renders Retirement::REVISION in the footer
- lib/retirement.rb already reads the file at load time

## LLM Context

- Files likely affected: bin/deploy
- Invariants to preserve: REVISION must not be committed to repo
- Style constraints: follow deploy-commit-sha skill pattern
- Known traps: file must be written before `make build`, not after
