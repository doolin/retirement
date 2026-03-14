# frozen_string_literal: true

module Retirement
  # A weighted collection of asset classes representing
  # an investment allocation. Computes blended return
  # and portfolio-level volatility for simulation.
  class Portfolio
    attr_reader :allocations

    def initialize(allocations = {})
      @allocations = allocations
      validate!
    end

    def blended_return
      weighted_sum(:expected_return)
    end

    def blended_volatility
      Math.sqrt(weighted_sum_sq(:volatility))
    end

    def describe
      allocations.map do |asset, weight|
        { name: asset.name, weight: weight }
      end
    end

    # Common preset portfolios.
    def self.aggressive
      new(
        AssetClass::STOCKS => 0.70,
        AssetClass::INTL_STOCKS => 0.20,
        AssetClass::BONDS => 0.10,
      )
    end

    def self.moderate
      new(
        AssetClass::STOCKS => 0.40,
        AssetClass::BONDS => 0.30,
        AssetClass::REAL_ESTATE => 0.15,
        AssetClass::INTL_STOCKS => 0.15,
      )
    end

    def self.conservative
      new(
        AssetClass::BONDS => 0.50,
        AssetClass::STOCKS => 0.20,
        AssetClass::CASH => 0.20,
        AssetClass::REAL_ESTATE => 0.10,
      )
    end

    private

    def weighted_sum(attr_name)
      allocations.sum do |asset, weight|
        weight * asset.send(attr_name)
      end
    end

    def weighted_sum_sq(attr_name)
      allocations.sum do |asset, weight|
        (weight * asset.send(attr_name))**2
      end
    end

    def validate!
      total = allocations.values.sum
      return if (total - 1.0).abs < 0.001

      raise ArgumentError, "Weights must sum to 1.0 (got #{total})"
    end
  end
end
