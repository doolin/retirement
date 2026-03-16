# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Statistics do
  let(:helper) { Object.new.extend(described_class) }

  describe "#gaussian" do
    it "does not crash when rand hits 0" do
      allow(helper).to receive(:rand).and_return(0.0, 0.5)
      expect { helper.gaussian }.not_to raise_error
    end
  end

  describe "#percentile" do
    it "returns 0.0 for empty input" do
      expect(helper.percentile([], 50)).to eq(0.0)
    end

    it "clamps percentile bounds" do
      sorted = [1.0, 2.0, 3.0]
      expect(helper.percentile(sorted, -50)).to eq(1.0)
      expect(helper.percentile(sorted, 500)).to eq(3.0)
    end

    it "ignores non-finite values" do
      sorted = [-Float::INFINITY, 1.0, Float::NAN, 3.0, Float::INFINITY]
      expect(helper.percentile(sorted, 50)).to eq(1.0)
    end
  end
end
