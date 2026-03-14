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
  end
end
