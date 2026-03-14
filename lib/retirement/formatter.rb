# frozen_string_literal: true

module Retirement
  # Formats projection results for terminal display.
  class Formatter
    HEADER = "Year  Balance         Income     Expenses"
    SEPARATOR = "-" * HEADER.length

    def initialize(projections)
      @projections = projections
    end

    def to_s
      lines = [HEADER, SEPARATOR]
      @projections.order(:year).each do |row|
        lines << format_row(row)
      end
      lines.join("\n")
    end

    private

    def format_row(row)
      format(
        "%<yr>4d  %<bal>14s  %<inc>9s  %<exp>9s",
        yr: row[:year],
        bal: currency(row[:balance]),
        inc: currency(row[:income]),
        exp: currency(row[:expenses]),
      )
    end

    def currency(amount)
      "$#{format("%<v>.2f", v: amount.to_f)}"
    end
  end
end
