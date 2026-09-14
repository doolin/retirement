# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, :test do
  gem "rack-test"
  gem "rspec"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov", require: false
end

# Audits the locked gems against the Ruby Advisory Database:
#   bundle exec bundle-audit check --update
gem "bundler-audit", require: false, groups: %i[development test]
