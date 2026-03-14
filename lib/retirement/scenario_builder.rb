# frozen_string_literal: true

module Retirement
  # Builds scenario hash and portfolio from form params.
  class ScenarioBuilder
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def scenario
      base_fields.merge(drawdown_fields)
    end

    def portfolio
      allocs = allocation_map
      return nil if allocs.values.sum < 0.01

      Portfolio.new(allocs)
    end

    def years
      (params[:years] || 30).to_i
    end

    private

    def base_fields
      {
        name: params[:name] || "custom",
        savings: float(:savings),
        annual_income: float(:annual_income),
        annual_expenses: float(:annual_expenses),
        return_rate: float(:return_rate),
        inflation_rate: float(:inflation_rate),
      }
    end

    def float(key)
      params[key].to_f
    end

    def drawdown_fields
      {
        drawdown_percent: params[:drawdown_percent].to_f,
        drawdown_fixed: params[:drawdown_fixed].to_f,
      }
    end

    def allocation_map
      {
        AssetClass::STOCKS => pct(:alloc_stocks),
        AssetClass::INTL_STOCKS => pct(:alloc_intl),
        AssetClass::BONDS => pct(:alloc_bonds),
        AssetClass::REAL_ESTATE => pct(:alloc_real_estate),
        AssetClass::CASH => pct(:alloc_cash),
      }.reject { |_, v| v.zero? }
    end

    def pct(key)
      (params[key].to_f / 100.0).round(4)
    end
  end
end
