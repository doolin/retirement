# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Portfolio do
  describe ".aggressive" do
    it "has a higher blended return than conservative" do
      aggressive = described_class.aggressive.blended_return
      conservative = described_class.conservative.blended_return
      expect(aggressive).to be > conservative
    end
  end

  describe ".conservative" do
    it "has lower volatility than aggressive" do
      conservative = described_class.conservative.blended_volatility
      aggressive = described_class.aggressive.blended_volatility
      expect(conservative).to be < aggressive
    end
  end

  describe "#describe" do
    it "lists allocations with names and weights" do
      desc = described_class.moderate.describe
      expect(desc.first).to include(:name, :weight)
    end
  end

  describe "validation" do
    it "raises when weights do not sum to 1.0" do
      expect do
        described_class.new(
          Retirement::AssetClass::STOCKS => 0.50,
        )
      end.to raise_error(ArgumentError, /sum to 1.0/)
    end
  end

  describe "with portfolio Monte Carlo" do
    it "produces results using portfolio allocation" do
      scenario = { savings: 100_000, annual_income: 0, annual_expenses: 0 }
      portfolio = described_class.moderate
      mc = Retirement::MonteCarlo.new(scenario, portfolio: portfolio)
      results = mc.run(trials: 100, years: 5)
      expect(results.length).to eq(5)
    end
  end
end
