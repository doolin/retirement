# frozen_string_literal: true

module Retirement
  # Runs Monte Carlo simulations over a retirement scenario.
  # Randomizes annual return rate using a normal distribution
  # to model market volatility, then aggregates percentile
  # outcomes across all trials.
  class MonteCarlo
    DEFAULT_TRIALS = 1_000
    DEFAULT_YEARS = 30
    DEFAULT_VOLATILITY = 0.15

    attr_reader :scenario, :volatility

    def initialize(scenario, volatility: DEFAULT_VOLATILITY)
      @scenario = scenario
      @volatility = volatility
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
      (balance * (1.0 + random_return)) + net_income
    end

    def random_return
      scenario[:return_rate] + (volatility * gaussian)
    end

    def gaussian
      u1 = rand
      u2 = rand
      Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math::PI * u2)
    end

    def net_income
      scenario[:annual_income].to_f -
        scenario[:annual_expenses].to_f
    end

    def summarize(results, years)
      Array.new(years) do |yi|
        year_balances = results.map { |r| r[yi] }.sort
        build_percentiles(yi + 1, year_balances)
      end
    end

    def build_percentiles(year, sorted)
      {
        year: year,
        p10: pct(sorted, 10),
        p50: pct(sorted, 50),
        p90: pct(sorted, 90),
      }
    end

    def pct(sorted, percentile)
      idx = (percentile / 100.0 * sorted.length).ceil - 1
      sorted[[idx, 0].max].round(2)
    end
  end
end
