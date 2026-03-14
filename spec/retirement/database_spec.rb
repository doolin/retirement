# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement::Database do
  describe ".connect" do
    it "returns a Sequel database" do
      db = described_class.connect
      expect(db.is_a?(Sequel::SQLite::Database)).to be(true)
    end

    it "creates the scenarios table" do
      db = described_class.connect
      expect(db.table_exists?(:scenarios)).to be(true)
    end

    it "creates the projections table" do
      db = described_class.connect
      expect(db.table_exists?(:projections)).to be(true)
    end
  end
end
