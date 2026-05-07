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

  describe "#years_until_retirement" do
    it "returns the gap when retirement is in the future" do
      scenario = { current_age: 50, retirement_age: 65 }
      expect(helper.years_until_retirement(scenario)).to eq(15)
    end

    it "clamps to zero when already retired" do
      scenario = { current_age: 70, retirement_age: 65 }
      expect(helper.years_until_retirement(scenario)).to eq(0)
    end

    it "defaults to 65/65 when fields are missing" do
      expect(helper.years_until_retirement({})).to eq(0)
    end
  end

  describe "#drawdown_for_year" do
    let(:scenario) do
      { drawdown_percent: 0.04, drawdown_fixed: 0,
        current_age: 50, retirement_age: 65 }
    end

    it "is zero before retirement year" do
      expect(helper.drawdown_for_year(100_000, scenario, 0)).to eq(0.0)
      expect(helper.drawdown_for_year(100_000, scenario, 14)).to eq(0.0)
    end

    it "applies the formula at and after retirement year" do
      expect(helper.drawdown_for_year(100_000, scenario, 15)).to eq(4_000)
      expect(helper.drawdown_for_year(100_000, scenario, 30)).to eq(4_000)
    end

    it "applies immediately when already retired" do
      now = scenario.merge(current_age: 70, retirement_age: 65)
      expect(helper.drawdown_for_year(100_000, now, 0)).to eq(4_000)
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
