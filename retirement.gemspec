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
  spec.required_ruby_version = ">= 4.0"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("{lib,exe}/**/*") + %w[README.md]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
