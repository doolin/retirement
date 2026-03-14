# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::AssetClass do
  describe "preset constants" do
    it "defines five asset classes" do
      expect(described_class::ALL.length).to eq(5)
    end

    it "gives stocks higher volatility than bonds" do
      stocks_vol = described_class::STOCKS.volatility
      bonds_vol = described_class::BONDS.volatility
      expect(stocks_vol).to be > bonds_vol
    end

    it "gives cash the lowest volatility" do
      cash_vol = described_class::CASH.volatility
      others = described_class::ALL.reject do |ac|
        ac == described_class::CASH
      end
      others.each do |ac|
        expect(cash_vol).to be < ac.volatility
      end
    end
  end

  describe "#initialize" do
    it "stores name, expected_return, and volatility" do
      ac = described_class.new(
        name: "Test",
        expected_return: 0.05,
        volatility: 0.10,
      )
      expect(ac.name).to eq("Test")
    end
  end
end
