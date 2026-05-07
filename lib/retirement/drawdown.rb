# frozen_string_literal: true

module Retirement
  # Computes annual drawdown and inflation-adjusted costs.
  # Supports percent-of-balance, fixed amount, or both, and
  # gates withdrawals so they only apply once retirement begins.
  module Drawdown
    def compute_drawdown(balance, scenario)
      pct = (scenario[:drawdown_percent] || 0).to_f
      fixed = (scenario[:drawdown_fixed] || 0).to_f
      (balance * pct) + fixed
    end

    def drawdown_for_year(balance, scenario, year)
      return 0.0 if year < years_until_retirement(scenario)

      compute_drawdown(balance, scenario)
    end

    def years_until_retirement(scenario)
      retirement = (scenario[:retirement_age] || 65).to_i
      current = (scenario[:current_age] || 65).to_i
      [retirement - current, 0].max
    end

    def inflation_factor(year, scenario)
      rate = (scenario[:inflation_rate] || 0).to_f
      (1.0 + rate)**year
    end
  end
end
