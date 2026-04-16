# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::IncomeSchedule do
  let(:scenario) do
    { current_age: 72, savings: 400_000.0, pretax_savings: 400_000.0,
      annual_income: 60_000.0, tax_rate: 0.25 }
  end
  let(:rows) do
    [{ year: 1, balance: 400_000.0 }, { year: 2, balance: 420_000.0 }]
  end
  let(:projections) { instance_double(Sequel::Dataset, order: rows) }

  describe ".build" do
    it "returns one row per projection year" do
      expect(described_class.build(scenario, projections).size).to eq(2)
    end

    it "applies tax rate to income plus RMD" do
      row = described_class.build(scenario, projections).first
      rmd = Retirement::Rmd.compute_rmd(400_000.0, 73)
      expected = (60_000.0 + rmd) * 0.75
      expect(row[:net_annual]).to be_within(0.01).of(expected)
    end

    it "divides yearly net by twelve for monthly net" do
      row = described_class.build(scenario, projections).first
      expect(row[:net_monthly]).to be_within(0.01).of(row[:net_annual] / 12.0)
    end

    it "taxes only base income before RMD age" do
      young = scenario.merge(current_age: 60)
      row = described_class.build(young, projections).first
      expect(row[:net_annual]).to be_within(0.01).of(60_000.0 * 0.75)
    end
  end
end
