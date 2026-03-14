# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::ScenarioBuilder do
  let(:params) do
    {
      name: "Test",
      savings: "500000",
      annual_income: "80000",
      annual_expenses: "50000",
      return_rate: "0.07",
      inflation_rate: "0.03",
      drawdown_percent: "0.04",
      drawdown_fixed: "0",
      alloc_stocks: "40",
      alloc_intl: "15",
      alloc_bonds: "30",
      alloc_real_estate: "15",
      alloc_cash: "0",
      years: "25",
    }
  end
  let(:builder) { described_class.new(params) }

  describe "#scenario" do
    it "parses savings as float" do
      expect(builder.scenario[:savings]).to eq(500_000.0)
    end

    it "includes inflation rate" do
      expect(builder.scenario[:inflation_rate]).to eq(0.03)
    end
  end

  describe "#portfolio" do
    it "builds a portfolio from allocation params" do
      portfolio = builder.portfolio
      expect(portfolio.is_a?(Retirement::Portfolio)).to be(true)
    end

    it "excludes zero-weight asset classes" do
      names = builder.portfolio.describe.map { |a| a[:name] }
      expect(names.include?("Cash/Money Market")).to be(false)
    end
  end

  describe "#years" do
    it "returns the projection years" do
      expect(builder.years).to eq(25)
    end
  end
end
