---
id: RC-0022
title: Add CD deploy job to CI pipeline
type: task
status: done
value: 5
effort: 2
urgency: 4
risk: 2
score: 4.5
owner: dave
created: 2026-04-13
updated: 2026-04-13
completed: 2026-04-13
parent: null
depends_on:
  - RC-0018
area: ci
adr_refs: []
links: []
labels:
  - ci
  - deploy
  - lambda
---

## Why

Deployment was manual via `bin/deploy` with local AWS credentials.
Continuous deployment on master push ensures every merged change
goes live automatically.

## Outcome

Pushes to master trigger: test -> deploy -> attest. The deploy job
bundles gems, writes REVISION, packages a zip, uploads to S3,
updates the Lambda, and invalidates CloudFront.

## Acceptance Criteria

- [x] Deploy job runs on master push only, after tests pass
- [x] Uses OIDC for AWS authentication (slacronym role)
- [x] Writes REVISION file with short commit SHA
- [x] Bundles gems for production (without dev/test)
- [x] Uploads deploy zip to retirement-deployments S3 bucket
- [x] Updates retirement Lambda function code
- [x] Waits for Lambda update to complete
- [x] Invalidates CloudFront /retirement* path
- [x] Terraform updated to grant slacronym OIDC role access to retirement resources

## Notes

- Slacronym OIDC role expanded with retirement Lambda + S3 permissions
  (same tech debt pattern as baa-or-not)
- Bundles natively on ubuntu runner instead of Docker SAM build
- CloudFront distribution ID: ERIW60YQ29CKU

## LLM Context

- Files likely affected: .github/workflows/ci.yml, form-terra/slacronym.tf
- Invariants to preserve: attest job must still run after deploy
- Style constraints: follow clubstraylight-lambda skill deploy pattern
- Known traps: lambda wait needs GetFunctionConfiguration permission
