---
id: BL-0011
title: Add S3 backup for SQLite database
type: story
status: backlog
value: 3                   # stated project goal, disaster recovery
effort: 2                  # aws-sdk-s3 + scheduled upload
urgency: 1                 # needs persistent storage first
risk: 2                    # AWS credentials handling
score: 2.0                 # (3 + 1) / 2
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed:
parent: null
depends_on: [BL-0010]
area: infrastructure
adr_refs: []
links: []
labels: [storage, backup, aws]
---

## Why

The README specifies S3 backup. A local encrypted SQLite file can be
lost to disk failure. Periodic S3 uploads provide offsite backup.

## Outcome

The app periodically uploads the encrypted SQLite database to a
configured S3 bucket, and can restore from the latest backup.

## Acceptance Criteria

- [ ] `aws-sdk-s3` gem added
- [ ] Configurable S3 bucket, prefix, and region
- [ ] Manual backup trigger from the UI or CLI
- [ ] Optional automatic backup on scenario save
- [ ] Restore command that downloads and replaces local DB
- [ ] Credentials via environment variables or AWS config

## Notes

- Upload the entire encrypted DB file — it's small.
- Version the uploads with timestamps in the S3 key.
- Depends on BL-0010 for on-disk storage.

## LLM Context

- Files likely affected: new `backup.rb`, `web.rb` (backup button), `Gemfile`
- Invariants to preserve: app works without S3 configured
- Style constraints: strict RuboCop
- Known traps: don't commit AWS credentials
