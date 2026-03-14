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

    get "/" do
      erb :index
    end

    post "/calculate" do
      db = Database.connect
      scenario_data = build_scenario(params)
      scenario_id = db[:scenarios].insert(scenario_data)
      calc = Calculator.new(db, scenario_id)
      projections = calc.project

      portfolio = resolve_portfolio(params[:portfolio])
      mc = MonteCarlo.new(scenario_data, portfolio: portfolio)
      mc_results = mc.run(trials: 1_000, years: 30)

      erb :results, locals: {
        scenario: scenario_data,
        projections: projections,
        monte_carlo: mc_results,
        portfolio: portfolio,
      }
    end

    private

    def build_scenario(params)
      {
        name: params[:name] || "custom",
        savings: params[:savings].to_f,
        annual_income: params[:annual_income].to_f,
        annual_expenses: params[:annual_expenses].to_f,
        return_rate: params[:return_rate].to_f,
      }
    end

    def resolve_portfolio(name)
      case name
      when "aggressive" then Portfolio.aggressive
      when "moderate" then Portfolio.moderate
      when "conservative" then Portfolio.conservative
      end
    end
  end
end
