# frozen_string_literal: true

module Retirement
  # Statistical utility methods for simulations.
  module Statistics
    def gaussian
      u1 = rand
      u2 = rand
      Math.sqrt(-2.0 * Math.log(u1)) *
        Math.cos(2.0 * Math::PI * u2)
    end

    def percentile(sorted, pct)
      idx = (pct / 100.0 * sorted.length).ceil - 1
      sorted[[idx, 0].max].round(2)
    end
  end
end
