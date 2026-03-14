# frozen_string_literal: true

require "lamby"
require_relative "config"

def handler(event:, context:)
  Lamby.handler(Retirement::Web, event, context)
end
