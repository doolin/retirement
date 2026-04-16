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

    it "returns nil when allocations do not sum to 100%" do
      bad_params = params.merge(alloc_stocks: "200", alloc_bonds: "0")
      expect(described_class.new(bad_params).portfolio.nil?).to be(true)
    end

    it "does not raise on mangled allocation payloads" do
      bad_params = params.merge(
        alloc_stocks: { nested: "40" },
        alloc_bonds: ["30"],
        alloc_real_estate: "Infinity",
      )
      expect { described_class.new(bad_params).portfolio }.not_to raise_error
    end
  end

  describe "#years" do
    it "returns the projection years" do
      expect(builder.years).to eq(25)
    end

    it "falls back to defaults for invalid values" do
      expect(described_class.new(params.merge(years: nil)).years).to eq(30)
      expect(described_class.new(params.merge(years: "bad")).years).to eq(30)
    end

    it "clamps years into a safe range" do
      expect(described_class.new(params.merge(years: "-50")).years).to eq(1)
      expect(described_class.new(params.merge(years: "10000")).years).to eq(100)
    end
  end

  describe "RMD fields" do
    it "parses current_age" do
      expect(builder.scenario[:current_age]).to eq(65)
    end

    it "parses pretax_savings" do
      p = params.merge(pretax_savings: "300000")
      expect(described_class.new(p).scenario[:pretax_savings]).to eq(300_000.0)
    end

    it "defaults pretax_savings to zero" do
      expect(builder.scenario[:pretax_savings]).to eq(0.0)
    end

    it "defaults current_age for invalid input" do
      p = params.merge(current_age: "bad")
      expect(described_class.new(p).scenario[:current_age]).to eq(65)
    end

    it "clamps current_age into range" do
      low = described_class.new(params.merge(current_age: "10"))
      high = described_class.new(params.merge(current_age: "200"))
      expect(low.scenario[:current_age]).to eq(18)
      expect(high.scenario[:current_age]).to eq(120)
    end
  end

  describe "mangled numeric inputs" do
    it "sanitizes malformed values without crashing" do
      fuzz_params = {
        name: { bad: true },
        savings: "NaN",
        annual_income: ["oops"],
        annual_expenses: { nested: "x" },
        return_rate: "Infinity",
        inflation_rate: "-99",
        drawdown_percent: "2.5",
        drawdown_fixed: "-1000",
      }

      scenario = described_class.new(fuzz_params).scenario
      expect(scenario[:savings]).to eq(0.0)
      expect(scenario[:annual_income]).to eq(0.0)
      expect(scenario[:annual_expenses]).to eq(0.0)
      expect(scenario[:return_rate]).to eq(0.07)
      expect(scenario[:inflation_rate]).to eq(-0.5)
      expect(scenario[:drawdown_percent]).to eq(1.0)
      expect(scenario[:drawdown_fixed]).to eq(0.0)
      expect(scenario[:name].nil?).to be(false)
    end
  end
end
