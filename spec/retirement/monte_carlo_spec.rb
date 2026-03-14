# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::MonteCarlo do
  let(:scenario) do
    {
      savings: 100_000,
      annual_income: 60_000,
      annual_expenses: 40_000,
      return_rate: 0.07,
    }
  end
  let(:mc) { described_class.new(scenario, volatility: 0.15) }

  describe "#run" do
    it "returns one entry per year" do
      results = mc.run(trials: 100, years: 10)
      expect(results.length).to eq(10)
    end

    it "includes percentile keys in each year" do
      row = mc.run(trials: 100, years: 1).first
      expect(row.keys).to include(:p10, :p50, :p90)
    end

    it "orders percentiles correctly" do
      row = mc.run(trials: 500, years: 5).last
      expect(row[:p10]).to be <= row[:p50]
    end

    it "produces p50 near deterministic projection" do
      row = mc.run(trials: 5_000, years: 1).first
      deterministic = (100_000 * 1.07) + 20_000
      expect(row[:p50]).to be_within(5_000).of(deterministic)
    end
  end
end
