# frozen_string_literal: true

module Retirement
  # Projects financial state over a 30-year horizon.
  # Each year applies investment returns, adds income,
  # and subtracts expenses to compute the ending balance.
  class Calculator
    DEFAULT_YEARS = 30

    attr_reader :db, :scenario

    def initialize(db, scenario_id)
      @db = db
      @scenario = db[:scenarios][id: scenario_id]
    end

    def project(years: DEFAULT_YEARS)
      balance = scenario[:savings].to_f
      years.times { |i| balance = project_year(i, balance) }
      db[:projections].where(scenario_id: scenario[:id])
    end

    private

    def project_year(index, balance)
      gains = balance * scenario[:return_rate]
      new_balance = balance + gains + net_income
      store_year(index, new_balance)
      new_balance
    end

    def net_income
      scenario[:annual_income].to_f -
        scenario[:annual_expenses].to_f
    end

    def store_year(index, balance)
      db[:projections].insert(
        scenario_id: scenario[:id],
        year: index + 1,
        balance: balance.round(2),
        income: scenario[:annual_income],
        expenses: scenario[:annual_expenses],
      )
    end
  end
end
