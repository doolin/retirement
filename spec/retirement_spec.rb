# frozen_string_literal: true

require "spec_helper"

RSpec.describe Retirement do
  it "has a version number" do
    expect(Retirement::VERSION.nil?).to be(false)
  end
end
