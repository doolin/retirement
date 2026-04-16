# frozen_string_literal: true

require "sequel"

module Retirement
  # Sets up an in-memory SQLite database and defines the schema
  # for tracking financial scenarios and yearly projections.
  module Database
    def self.connect
      db = Sequel.sqlite
      create_scenarios_table(db)
      create_projections_table(db)
      db
    end

    def self.create_scenarios_table(db)
      db.create_table(:scenarios) do
        primary_key :id
        String :name, null: false
        Numeric :savings, default: 0
        Numeric :annual_income, default: 0
        Numeric :annual_expenses, default: 0
        Float :return_rate, default: 0.07
        Float :inflation_rate, default: 0.03
        Float :drawdown_percent, default: 0.0
        Numeric :drawdown_fixed, default: 0
        Integer :current_age, default: 65
        Numeric :pretax_savings, default: 0
        Numeric :roth_savings, default: 0
        Float :tax_rate, default: 0.22
      end
    end

    def self.create_projections_table(db)
      db.create_table(:projections) do
        primary_key :id
        foreign_key :scenario_id, :scenarios
        Integer :year, null: false
        Numeric :balance, default: 0
        Numeric :income, default: 0
        Numeric :expenses, default: 0
      end
    end

    private_class_method :create_scenarios_table,
                         :create_projections_table
  end
end
