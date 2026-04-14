# frozen_string_literal: true

require "spec_helper"
require "rack/test"
require_relative "../../lib/retirement/web"

RSpec.describe Retirement::Web do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe "POST /retirement/calculate" do
    it "handles mangled form payloads without 500 errors" do
      payload = {
        name: "fuzz",
        savings: { nested: "100000" },
        annual_income: ["bad"],
        annual_expenses: "Infinity",
        return_rate: "NaN",
        inflation_rate: "-99",
        drawdown_percent: "999",
        drawdown_fixed: "-5000",
        alloc_stocks: "250",
        alloc_intl: "-20",
        alloc_bonds: "abc",
        alloc_real_estate: "",
        alloc_cash: nil,
        years: "-50",
      }

      post "/retirement/calculate", payload
      expect(last_response.status).to eq(200)
      expect(last_response.body.include?("Retirement Calculator")).to be(true)
    end

    it "handles non-hash payload root keys gracefully" do
      post "/retirement/calculate", "not=form&data=true",
           "CONTENT_TYPE" => "application/x-www-form-urlencoded"
      expect(last_response.status).to eq(200)
    end
  end
end
