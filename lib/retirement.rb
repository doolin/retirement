# frozen_string_literal: true

require_relative "retirement/version"
require_relative "retirement/database"
require_relative "retirement/calculator"
require_relative "retirement/statistics"
require_relative "retirement/drawdown"
require_relative "retirement/returns"
require_relative "retirement/asset_class"
require_relative "retirement/portfolio"
require_relative "retirement/scenario_builder"
require_relative "retirement/formatter"
require_relative "retirement/monte_carlo"
require_relative "retirement/monte_carlo_formatter"

# Retirement financial planning calculator.
module Retirement
  REVISION = if File.exist?(File.expand_path("../../REVISION", __dir__))
               File.read(File.expand_path("../../REVISION", __dir__)).strip
             elsif system("git rev-parse --short HEAD >/dev/null 2>&1")
               `git rev-parse --short HEAD`.strip
             end
end
