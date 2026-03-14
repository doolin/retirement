# frozen_string_literal: true

module Retirement
  # Computes investment returns for a given year,
  # either from a portfolio or a simple rate+volatility.
  module Returns
    include Statistics

    def year_return(scenario, portfolio)
      return simple_return(scenario) unless portfolio

      portfolio.allocations.sum do |asset, weight|
        weight * asset_return(asset)
      end
    end

    private

    def simple_return(scenario)
      rate = scenario[:return_rate] || 0.07
      vol = scenario[:volatility] || 0.15
      rate + (vol * gaussian)
    end

    def asset_return(asset)
      asset.expected_return + (asset.volatility * gaussian)
    end
  end
end
