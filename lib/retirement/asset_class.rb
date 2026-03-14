# frozen_string_literal: true

module Retirement
  # Models an investment asset class with its expected
  # return and volatility (standard deviation of returns).
  class AssetClass
    attr_reader :name, :expected_return, :volatility

    def initialize(name:, expected_return:, volatility:)
      @name = name
      @expected_return = expected_return
      @volatility = volatility
    end

    # Predefined asset classes with historical risk profiles.
    STOCKS = new(
      name: "US Stocks",
      expected_return: 0.10,
      volatility: 0.20,
    )

    BONDS = new(
      name: "Bonds",
      expected_return: 0.04,
      volatility: 0.06,
    )

    CASH = new(
      name: "Cash/Money Market",
      expected_return: 0.02,
      volatility: 0.01,
    )

    REAL_ESTATE = new(
      name: "Real Estate (REITs)",
      expected_return: 0.08,
      volatility: 0.18,
    )

    INTL_STOCKS = new(
      name: "International Stocks",
      expected_return: 0.08,
      volatility: 0.22,
    )

    ALL = [STOCKS, BONDS, CASH, REAL_ESTATE, INTL_STOCKS].freeze
  end
end
