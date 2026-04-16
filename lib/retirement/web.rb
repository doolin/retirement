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
    set :host_authorization, permitted: :any

    helpers do
      def commify(number)
        number.to_f.round(0).to_i.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
      end
    end

    get %r{/(retirement)?} do
      erb :index
    end

    post %r{/(retirement/)?calculate} do
      builder = ScenarioBuilder.new(params)
      results = run_projections(builder)
      erb :results, locals: results
    end

    private

    def run_projections(builder)
      scenario = builder.scenario
      projections = deterministic(scenario, builder.years)
      mc = monte_carlo(scenario, builder)
      rmd = rmd_schedule(scenario, projections)
      { scenario: scenario, projections: projections,
        monte_carlo: mc, portfolio: builder.portfolio, rmd_schedule: rmd }
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

    def rmd_schedule(scenario, projections)
      frac = pretax_fraction(scenario)
      age = scenario[:current_age].to_i
      projections.order(:year).map { |row| rmd_row(row, age, frac) }
    end

    def rmd_row(row, base_age, frac)
      yr_age = base_age + row[:year]
      rmd = Rmd.compute_rmd(row[:balance].to_f * frac, yr_age)
      { year: row[:year], age: yr_age, rmd: rmd }
    end

    def pretax_fraction(scenario)
      total = scenario[:savings].to_f
      return 0.0 if total <= 0

      pretax = (scenario[:pretax_savings] || 0).to_f
      (pretax / total).clamp(0.0, 1.0)
    end
  end
end
