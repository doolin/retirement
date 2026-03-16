---
id: RC-0016
title: Deploy Sinatra app to AWS Lambda
type: task
status: done
value: 5                   # enables remote access, unblocks RC-0003
effort: 3                  # new infra, packaging, SAM/CF template
urgency: 4                 # user wants it now
risk: 2                    # well-trodden path with lamby/rack adapters
score: 3.0                 # (5 + 4) / 3
owner: dave
created: 2026-03-14
updated: 2026-03-14
completed: 2026-03-14
parent: null
depends_on: []
area: infrastructure
adr_refs: []
links: []
labels: [deploy, aws, lambda, infrastructure]
---

## Why

The app currently only runs locally via Puma. Deploying to AWS Lambda
behind a Function URL (or API Gateway) makes it accessible from any
device without tunneling or always-on servers.

## Outcome

A single `sam deploy` (or equivalent) packages the Sinatra app and
deploys it as an AWS Lambda function with an HTTP endpoint, backed by
an S3 bucket for deployment artifacts.

## Acceptance Criteria

- [x] Lambda handler adapts the Rack/Sinatra app (e.g. via `lamby` gem or rack-lambda)
- [x] SAM/CloudFormation template defines the function, HTTP API, and IAM role
- [x] Deployment artifact is uploaded to a provided S3 bucket
- [ ] App responds to HTTP requests at the Lambda Function URL
- [x] `sam build && sam deploy` (or script) works from the repo root

## Notes

- User will provide the S3 bucket name for deployment artifacts.
- Sinatra app is in `lib/retirement/web.rb`, entry point is `config.ru`.
- SQLite won't persist on Lambda; persistence (RC-0010) is a separate concern.
- Consider using `lamby` gem for clean Rack-to-Lambda integration.
- Lambda has a 250 MB unzipped package limit; native gems (sqlite3) need
  a Lambda-compatible build (x86_64-linux or provided.al2023).

## LLM Context

- Files likely affected: `config.ru`, `template.yaml` (new), `lambda_handler.rb` (new), `Gemfile`, `retirement.gemspec`
- Invariants to preserve: local `rackup` / `puma` still works
- Style constraints: follow existing gemspec/Gemfile patterns
- Known traps: native sqlite3 gem needs Linux build for Lambda; bundler packaging for Lambda layers
