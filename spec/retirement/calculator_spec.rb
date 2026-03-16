# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Calculator do
  let(:db) { Retirement::Database.connect }
  let(:scenario_id) do
    db[:scenarios].insert(
      name: "baseline",
      savings: 100_000,
      annual_income: 60_000,
      annual_expenses: 40_000,
      return_rate: 0.07,
    )
  end
  let(:calculator) { described_class.new(db, scenario_id) }

  def project_count_for(years)
    sid = db[:scenarios].insert(
      name: "baseline",
      savings: 100_000,
      annual_income: 60_000,
      annual_expenses: 40_000,
      return_rate: 0.07,
    )
    described_class.new(db, sid).project(years: years).count
  end

  describe "#project" do
    it "generates 30 years by default" do
      results = calculator.project
      expect(results.count).to eq(30)
    end

    it "generates the requested number of years" do
      results = calculator.project(years: 5)
      expect(results.count).to eq(5)
    end

    it "grows the balance with returns and net income" do
      results = calculator.project(years: 1)
      row = results.first

      expected = (100_000 * 1.07) + 20_000
      expect(row[:balance].to_f).to eq(expected)
    end

    it "compounds returns over multiple years" do
      calculator.project(years: 2)
      balances = db[:projections].order(:year).map do |r|
        r[:balance].to_f
      end

      expect(balances[1]).to be > balances[0]
    end

    it "coerces malformed years to safe defaults" do
      expect(project_count_for("oops")).to eq(30)
      expect(project_count_for(-100)).to eq(30)
      expect(project_count_for(1000)).to eq(100)
    end
  end
end
