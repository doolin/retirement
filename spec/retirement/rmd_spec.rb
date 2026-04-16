# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Rmd do
  describe ".rmd_factor" do
    it "returns 0 for ages below 73" do
      expect(described_class.rmd_factor(65)).to eq(0.0)
    end

    it "returns the distribution period at age 73" do
      expect(described_class.rmd_factor(73)).to eq(26.5)
    end

    it "returns decreasing periods for older ages" do
      expect(described_class.rmd_factor(85)).to be < described_class.rmd_factor(73)
    end

    it "clamps to max table age" do
      expect(described_class.rmd_factor(130)).to eq(2.0)
    end
  end

  describe ".compute_rmd" do
    it "returns zero for ages below 73" do
      expect(described_class.compute_rmd(500_000, 65)).to eq(0.0)
    end

    it "divides pretax balance by distribution period" do
      rmd = described_class.compute_rmd(500_000, 73)
      expect(rmd).to be_within(1.0).of(18_867.92)
    end

    it "increases as age rises" do
      younger = described_class.compute_rmd(500_000, 73)
      older = described_class.compute_rmd(500_000, 85)
      expect(older).to be > younger
    end

    it "returns zero when pretax balance is zero" do
      expect(described_class.compute_rmd(0, 80)).to eq(0.0)
    end
  end
end
