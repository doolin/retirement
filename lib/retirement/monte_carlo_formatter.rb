# frozen_string_literal: true

module Retirement
  # Formats Monte Carlo percentile results for terminal display.
  class MonteCarloFormatter
    HEADER = "Year    P10 (worst)       P50 (median)      P90 (best)"
    SEPARATOR = "-" * HEADER.length

    def initialize(summary)
      @summary = summary
    end

    def to_s
      lines = [HEADER, SEPARATOR]
      @summary.each { |row| lines << format_row(row) }
      lines.join("\n")
    end

    private

    def format_row(row)
      format(
        "%<yr>4d  %<p10>16s  %<p50>16s  %<p90>16s",
        yr: row[:year],
        p10: currency(row[:p10]),
        p50: currency(row[:p50]),
        p90: currency(row[:p90]),
      )
    end

    def currency(amount)
      "$#{format("%<v>.2f", v: amount.to_f)}"
    end
  end
end
