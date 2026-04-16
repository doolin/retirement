# frozen_string_literal: true

module Retirement
  # Builds scenario hash and portfolio from form params.
  class ScenarioBuilder
    DEFAULT_YEARS = 30
    MAX_YEARS = 100

    attr_reader :params

    def initialize(params)
      @params = params.is_a?(Hash) ? params : {}
    end

    def scenario
      base_fields.merge(drawdown_fields).merge(rmd_fields).merge(tax_fields)
    end

    def portfolio
      allocs = allocation_map
      total = allocs.values.sum
      return nil if total < 0.01
      return nil unless (total - 1.0).abs < 0.001

      Portfolio.new(allocs)
    rescue ArgumentError
      nil
    end

    def years
      int(:years, default: DEFAULT_YEARS, min: 1, max: MAX_YEARS)
    end

    private

    def base_fields
      {
        name: params[:name] || "custom",
        savings: float(:savings, min: 0.0),
        annual_income: float(:annual_income, min: 0.0),
        annual_expenses: float(:annual_expenses, min: 0.0),
        return_rate: float(:return_rate, default: 0.07, min: -1.0, max: 1.0),
        inflation_rate: float(:inflation_rate, min: -0.5, max: 1.0),
      }
    end

    def float(key, default: 0.0, min: nil, max: nil)
      value = to_float(params[key], default)
      value = [value, min].max if min
      value = [value, max].min if max
      value
    end

    def drawdown_fields
      {
        drawdown_percent: float(:drawdown_percent, min: 0.0, max: 1.0),
        drawdown_fixed: float(:drawdown_fixed, min: 0.0),
      }
    end

    def rmd_fields
      {
        current_age: int(:current_age, default: 65, min: 18, max: 120),
        pretax_savings: float(:pretax_savings, min: 0.0),
        roth_savings: float(:roth_savings, min: 0.0),
      }
    end

    def tax_fields
      { tax_rate: float(:tax_rate, default: 0.22, min: 0.0, max: 1.0) }
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
      (float(key, min: 0.0, max: 100.0) / 100.0).round(4)
    end

    def int(key, default:, min:, max:)
      value = to_float(params[key], default).to_i
      value = [value, min].max
      [value, max].min
    end

    def to_float(value, default)
      return default if value.nil?
      return default if value.respond_to?(:strip) && value.strip.empty?
      return value.to_f if value.is_a?(Numeric) && value.finite?

      candidate = Float(value)
      return default unless candidate.finite?

      candidate
    rescue StandardError
      default
    end
  end
end
