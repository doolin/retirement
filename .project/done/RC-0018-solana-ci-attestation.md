---
id: RC-0018
title: Add Solana CI/CD artifact attestation pipeline
type: task
status: done
value: 4
effort: 3
urgency: 3
risk: 2
score: 2.3
owner: dave
created: 2026-04-13
updated: 2026-04-13
completed: 2026-04-13
parent: null
depends_on: []
area: ci
adr_refs: []
links:
  - https://github.com/doolin/dave-skills/blob/master/skills/solana-cicd-hash/SKILL.md
labels:
  - ci
  - solana
  - attestation
---

## Why

Tamper-proof, on-chain record that CI ran for a specific commit and
what it produced. Provides verifiable build provenance via Solana
memo transaction and S3 artifact archive.

## Outcome

Every push to master zips CI output, SHA-256 hashes the bundle, posts
the hash to Solana memo program (v2), generates a PDF attestation
report, and uploads everything to S3.

## Acceptance Criteria

- [x] RSpec and RuboCop output captured with commit-hash headers
- [x] Artifacts uploaded with 90-day retention
- [x] `attest` job runs on master push only
- [x] Solana keypair written securely (printf, chmod 600, cleanup with if: always())
- [x] AWS OIDC role assumed for S3 upload
- [x] Solana and S3 steps are fault-tolerant (failures logged, CI continues)
- [x] Attestation zip + PDF uploaded as GitHub Actions artifacts
- [x] GitHub secrets/variables configured (SOLANA_KEYPAIR, AWS_ROLE_ARN, S3_COMPLIANCE_BUCKET)

## Notes

- Uses reference `attest.mjs` from doolin/dave-skills
- ARTIFACT_FILES manifest: rspec-results.txt, rubocop-results.txt
- Reuses slacronym OIDC role (repo:* trust policy) — tech debt per
  clubstraylight-tech-debt skill
- S3 bucket: slacronym-artifacts
- Solana network: devnet (default)

## LLM Context

- Files likely affected: .github/workflows/ci.yml, scripts/attest.mjs, scripts/package.json, .gitignore
- Invariants to preserve: existing test and rubocop steps must still fail CI on errors
- Style constraints: follow artifact capture pattern from solana-cicd-hash SKILL.md
- Known traps: use Memo v2 program ID, printf not echo for keypair, ARTIFACT_FILES drift
