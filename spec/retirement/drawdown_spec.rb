# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Drawdown do
  let(:helper) { Object.new.extend(described_class) }

  describe "#compute_drawdown" do
    it "computes percent-of-balance drawdown" do
      scenario = { drawdown_percent: 0.04, drawdown_fixed: 0 }
      expect(helper.compute_drawdown(100_000, scenario)).to eq(4_000)
    end

    it "computes fixed drawdown" do
      scenario = { drawdown_percent: 0, drawdown_fixed: 10_000 }
      expect(helper.compute_drawdown(100_000, scenario)).to eq(10_000)
    end

    it "combines percent and fixed" do
      scenario = { drawdown_percent: 0.04, drawdown_fixed: 5_000 }
      result = helper.compute_drawdown(100_000, scenario)
      expect(result).to eq(9_000)
    end
  end

  describe "#inflation_factor" do
    it "returns 1.0 for year zero" do
      scenario = { inflation_rate: 0.03 }
      expect(helper.inflation_factor(0, scenario)).to eq(1.0)
    end

    it "compounds over years" do
      scenario = { inflation_rate: 0.03 }
      result = helper.inflation_factor(10, scenario)
      expect(result).to be_within(0.01).of(1.3439)
    end
  end
end
