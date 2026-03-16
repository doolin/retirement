# frozen_string_literal: true

module Retirement
  # Runs Monte Carlo simulations over a retirement scenario.
  # Supports portfolio-based returns, inflation adjustment,
  # and configurable drawdown (percent or fixed).
  class MonteCarlo
    include Statistics
    include Drawdown
    include Returns

    DEFAULT_TRIALS = 1_000
    DEFAULT_YEARS = 30
    MAX_TRIALS = 20_000
    MAX_YEARS = 100

    attr_reader :scenario, :portfolio

    def initialize(scenario, portfolio: nil)
      @scenario = scenario
      @portfolio = portfolio
    end

    def run(trials: DEFAULT_TRIALS, years: DEFAULT_YEARS)
      safe_trials = coerce_positive_int(trials, default: DEFAULT_TRIALS, max: MAX_TRIALS)
      safe_years = coerce_positive_int(years, default: DEFAULT_YEARS, max: MAX_YEARS)
      results = Array.new(safe_trials) { simulate(safe_years) }
      summarize(results, safe_years)
    end

    private

    def simulate(years)
      balance = scenario[:savings].to_f
      Array.new(years) do |yr|
        balance = step(balance, yr)
      end
    end

    def step(balance, year)
      growth = balance * (1.0 + year_return(scenario, portfolio))
      adjusted_dd = adjusted_drawdown(balance, year)
      growth - adjusted_dd + net_income
    end

    def adjusted_drawdown(balance, year)
      compute_drawdown(balance, scenario) *
        inflation_factor(year, scenario)
    end

    def net_income
      scenario[:annual_income].to_f -
        scenario[:annual_expenses].to_f
    end

    def summarize(results, years)
      Array.new(years) do |yi|
        sorted = results.map { |r| r[yi] }.sort
        pcts = { p10: 10, p50: 50, p90: 90 }
        pcts.transform_values! { |v| percentile(sorted, v) }
        pcts.merge(year: yi + 1)
      end
    end

    def coerce_positive_int(value, default:, max:)
      int_value = value.to_i
      int_value = default if int_value <= 0
      [int_value, max].min
    rescue StandardError
      default
    end
  end
end
