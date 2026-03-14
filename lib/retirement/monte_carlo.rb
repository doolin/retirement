# frozen_string_literal: true

module Retirement
  # Runs Monte Carlo simulations over a retirement scenario.
  # When given a Portfolio, uses per-asset return/volatility.
  # Falls back to scenario-level return_rate and volatility.
  class MonteCarlo
    include Statistics

    DEFAULT_TRIALS = 1_000
    DEFAULT_YEARS = 30

    attr_reader :scenario, :portfolio

    def initialize(scenario, portfolio: nil)
      @scenario = scenario
      @portfolio = portfolio
    end

    def run(trials: DEFAULT_TRIALS, years: DEFAULT_YEARS)
      results = Array.new(trials) { simulate(years) }
      summarize(results, years)
    end

    private

    def simulate(years)
      balance = scenario[:savings].to_f
      Array.new(years) { balance = step(balance) }
    end

    def step(balance)
      (balance * (1.0 + portfolio_return)) + net_income
    end

    def portfolio_return
      return simple_return unless portfolio

      portfolio.allocations.sum do |asset, weight|
        weight * asset_return(asset)
      end
    end

    def simple_return
      rate = scenario[:return_rate] || 0.07
      vol = scenario[:volatility] || 0.15
      rate + (vol * gaussian)
    end

    def asset_return(asset)
      asset.expected_return + (asset.volatility * gaussian)
    end

    def net_income
      scenario[:annual_income].to_f -
        scenario[:annual_expenses].to_f
    end

    def summarize(results, years)
      Array.new(years) do |yi|
        year_vals = results.map { |r| r[yi] }.sort
        build_percentiles(yi + 1, year_vals)
      end
    end

    def build_percentiles(year, sorted)
      {
        year: year,
        p10: percentile(sorted, 10),
        p50: percentile(sorted, 50),
        p90: percentile(sorted, 90),
      }
    end
  end
end
