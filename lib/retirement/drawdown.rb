# frozen_string_literal: true

module Retirement
  # Computes annual drawdown and inflation-adjusted costs.
  # Supports percent-of-balance, fixed amount, or both.
  module Drawdown
    def compute_drawdown(balance, scenario)
      pct = (scenario[:drawdown_percent] || 0).to_f
      fixed = (scenario[:drawdown_fixed] || 0).to_f
      (balance * pct) + fixed
    end

    def inflation_factor(year, scenario)
      rate = (scenario[:inflation_rate] || 0).to_f
      (1.0 + rate)**year
    end
  end
end
