# frozen_string_literal: true

require_relative "lib/retirement/version"

Gem::Specification.new do |spec|
  spec.name = "retirement"
  spec.version = Retirement::VERSION
  spec.authors = ["Dave Doolin"]
  spec.summary = "Retirement financial calculator"
  spec.description = "Track finances and compute statistical projections for retirement planning."
  spec.homepage = "https://github.com/doolin/retirement"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("{lib,exe}/**/*") + %w[README.md config.ru config.rb app.rb]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lamby", "~> 5.0"
  spec.add_dependency "puma", "~> 7.0"
  spec.add_dependency "sequel", "~> 5.0"
  spec.add_dependency "sinatra", "~> 4.0"
  spec.add_dependency "sqlite3", "~> 2.0"
end
