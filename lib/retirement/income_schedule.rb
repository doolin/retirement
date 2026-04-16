# frozen_string_literal: true

module Retirement
  # Builds per-year rows of RMD and after-tax income given a
  # scenario and the deterministic projections it produced.
  module IncomeSchedule
    module_function

    def build(scenario, projections)
      ctx = context(scenario)
      projections.order(:year).map { |row| row_for(row, ctx) }
    end

    def context(scenario)
      {
        base_age: scenario[:current_age].to_i,
        frac: pretax_fraction(scenario),
        income: scenario[:annual_income].to_f,
        tax_rate: scenario[:tax_rate].to_f,
      }
    end

    def row_for(row, ctx)
      yr_age = ctx[:base_age] + row[:year]
      rmd = Rmd.compute_rmd(row[:balance].to_f * ctx[:frac], yr_age)
      { year: row[:year], age: yr_age, rmd: rmd }.merge(after_tax(rmd, ctx))
    end

    def after_tax(rmd, ctx)
      net_annual = (ctx[:income] + rmd) * (1.0 - ctx[:tax_rate])
      { net_annual: net_annual, net_monthly: net_annual / 12.0 }
    end

    def pretax_fraction(scenario)
      total = scenario[:savings].to_f
      return 0.0 if total <= 0

      pretax = (scenario[:pretax_savings] || 0).to_f
      (pretax / total).clamp(0.0, 1.0)
    end
  end
end
