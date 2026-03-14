# frozen_string_literal: true

require "sinatra/base"
require "json"
require_relative "../retirement"

module Retirement
  # Sinatra web application for the retirement calculator.
  # Serves a form for scenario input and displays both
  # deterministic projections and Monte Carlo results.
  class Web < Sinatra::Base
    set :views, File.join(__dir__, "views")

    helpers do
      def commify(number)
        number.to_f.round(0).to_i.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
      end
    end

    get "/" do
      erb :index
    end

    post "/calculate" do
      builder = ScenarioBuilder.new(params)
      results = run_projections(builder)
      erb :results, locals: results
    end

    private

    def run_projections(builder)
      scenario = builder.scenario
      projections = deterministic(scenario, builder.years)
      mc = monte_carlo(scenario, builder)
      { scenario: scenario, projections: projections,
        monte_carlo: mc, portfolio: builder.portfolio }
    end

    def deterministic(scenario, years)
      db = Database.connect
      sid = db[:scenarios].insert(scenario)
      Calculator.new(db, sid).project(years: years)
    end

    def monte_carlo(scenario, builder)
      mc = MonteCarlo.new(scenario, portfolio: builder.portfolio)
      mc.run(trials: 1_000, years: builder.years)
    end
  end
end
