---
id: RC-0023
title: Migrate to Ruby 4.0 and patch gem security advisories
type: task                 # task | bug | spike | story | epic
status: done               # backlog | ready | in_progress | blocked | done
value: 4                   # 1–5 impact
effort: 2                  # 1–5 relative effort
urgency: 4                 # 1–5 time pressure
risk: 2                    # 1–5 uncertainty / blast radius
score: null                # computed, not authoritative
owner: dave
created: 2026-07-06
updated: 2026-07-06
completed: 2026-07-06
parent: null
depends_on: []
area: infra
adr_refs: []
links: []
labels: [maintenance, security, ruby]
---

## Why

Routine stewardship pass. `bundle-audit` flagged six advisories, three
High severity (puma x2, mcp). Ruby 3.3 reaches EOL ~Mar 2027 and is the
shortest-runway Lambda runtime. BL-0017 pinned the project to 3.3 in
Mar 2026 "for Lambda compatibility", but AWS has since shipped the
`ruby4.0` managed runtime (deprecation Mar 2029), so that constraint no
longer holds — this reverses BL-0017.

## Outcome

Project runs on Ruby 4.0.5, deploys to the Lambda `ruby4.0` runtime, and
`bundle-audit` reports zero vulnerabilities.

## Acceptance Criteria

- [x] `.ruby-version` → 4.0.5; gemspec `required_ruby_version` → `>= 4.0`
- [x] CI (test + deploy jobs) set up Ruby 4.0
- [x] Deploy flips the Lambda function runtime to `ruby4.0`
- [x] Security bumps: puma 7.2.1, mcp 0.22.0, json 2.20.0, addressable 2.9.0
- [x] `bundle-audit` clean; rspec green; rubocop clean

## Notes

- Reverses BL-0017 (the 3.3 Lambda pin), now obsolete.
- mcp could only advance to 0.22.0 once on Ruby 4.0 — its newer releases
  require Ruby 4.x, which is why the advisory sat unfixable under 3.3.
- puma held at 7.2.1 (fixes both CVEs within the `~> 7.0` constraint).
  The remaining major bumps — puma 8, lamby 7, mustermann 4, parallel 2,
  diff-lcs 2 — belong in a separate one-at-a-time pass.
- Lockfile re-bundled under bundler 4.0.10.
- Folded in a small pre-existing deploy change: the S3 bucket is now
  configurable via the `DEPLOY_S3_BUCKET` CI variable.

## LLM Context

- Files affected: `.ruby-version`, `retirement.gemspec`, `Gemfile.lock`,
  `.github/workflows/ci.yml`, `bin/deploy`
- Invariants to preserve: Lambda-deployable; native gems match runtime
- Known traps: run bundle under the 4.0.5 gemset's bundler (4.0.10), not
  a stray 2.5.22 pulled in by a corrupted `BUNDLED WITH`
