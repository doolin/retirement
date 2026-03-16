---
id: RC-0010
title: Persist scenarios to encrypted SQLite on disk
type: story
status: backlog
value: 5                   # stated project goal
effort: 3                  # file path config, encryption, migrations
urgency: 3                 # data is lost on every restart
risk: 2                    # well-understood tools
score: 2.67                # (5 + 3) / 3
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: []
area: infrastructure
adr_refs: []
links: []
labels: [storage, encryption]
---

## Why

The README states the app should "save into an encrypted sqlite database
which is backed up to S3." Currently the database is in-memory only —
all data is lost when the server stops. Users need to save, reload,
and compare scenarios across sessions.

## Outcome

Scenarios and projections persist to an encrypted SQLite file on disk.
The app loads existing scenarios on startup and allows creating new ones.

## Acceptance Criteria

- [ ] SQLite database file stored at a configurable path (default `~/.retirement/data.db`)
- [ ] Database encrypted at rest (sqlcipher or application-level encryption)
- [ ] Scenarios persist across server restarts
- [ ] UI lists saved scenarios and allows loading them
- [ ] UI allows deleting old scenarios
- [ ] Specs test persistence round-trip

## Notes

- `sqlcipher` gem wraps SQLCipher (SQLite with AES-256 encryption).
  Alternative: `sequel_sqlcipher` adapter.
- Application-level encryption (encrypt before insert) is simpler but
  less transparent to queries.
- Migration strategy: Sequel has a built-in migrator.

## LLM Context

- Files likely affected: `database.rb`, `web.rb`, new `views/scenarios.erb`, `Gemfile`
- Invariants to preserve: in-memory mode should still work for tests
- Style constraints: strict RuboCop
- Known traps: sqlcipher needs native libs installed, may complicate CI
