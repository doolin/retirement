# Retirement Calculator

The goal of this calculator is to both track current financial state and
expenditures, allow continuous updating, while also computing statistical
projections of future state based on current state and expenditures.

The tool will be web based, run only locally, and save into an encrypted sqlite
database which is backed up to S3.

## Quick Start

```bash
bundle install
rackup config.ru -p 4567 -o 0.0.0.0
```

Open http://localhost:4567 in your browser.

## Features

- **30-year financial projections** with deterministic and Monte Carlo simulation
- **5 asset classes** with historical risk/return profiles:
  US Stocks, International Stocks, Bonds, Real Estate (REITs), Cash
- **Custom portfolio allocation** with per-asset-class percentage inputs
- **Inflation modeling** compounding annually
- **Drawdown strategies**: percent-of-balance, fixed annual amount, or both
- **Interactive charts**: balance over time, Monte Carlo fan chart (p10/p50/p90),
  portfolio allocation doughnut
- **Mobile-friendly** responsive UI

## Accessing from a Phone

The app runs on localhost. To access it from another device (e.g., iPhone):

| Method | Setup | Notes |
|--------|-------|-------|
| **ngrok** | `ngrok http 4567` | Gives a public `https://` URL. Free tier available. |
| **Tailscale** | Install on both devices | Mesh VPN, access via Tailscale IP. No port forwarding. |
| **SSH tunnel** | `ssh -R 8080:localhost:4567 your-server` | Expose via a remote server you control. |
| **Deploy** | Push to Fly.io / Render / Railway | Persistent public URL. |
| **Local network** | `rackup -o 0.0.0.0 -p 4567` | Works if both devices are on the same Wi-Fi and your machine's local IP is reachable. |

## Deploy to AWS Lambda

Requires [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html), Docker, and configured AWS credentials.
Infrastructure (Lambda, Function URL, CloudFront) is managed by Terraform in `form-terra`.

```bash
bin/build    # writes REVISION, runs sam build (Docker bundles gems for Lambda)
bin/deploy   # zips artifacts, uploads to S3, updates Lambda, invalidates CloudFront
```

Served at `clubstraylight.com/retirement` via CloudFront.

## Development

```bash
bundle exec rspec       # run tests
bundle exec rubocop     # lint
ruby -Ilib exe/retirement  # CLI output
```

## Architecture

```
lib/retirement/
  asset_class.rb       # 5 asset types with return/volatility
  portfolio.rb         # weighted allocation, blended risk
  calculator.rb        # deterministic year-by-year projection
  monte_carlo.rb       # 1,000-trial simulation with percentiles
  drawdown.rb          # percent + fixed withdrawal logic
  returns.rb           # per-asset or simple return generation
  statistics.rb        # gaussian (Box-Muller) + percentile math
  database.rb          # in-memory SQLite via Sequel
  scenario_builder.rb  # parses web form into scenario + portfolio
  web.rb               # Sinatra app
  views/               # ERB templates with Chart.js
```
