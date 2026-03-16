# frozen_string_literal: true

module Retirement
  # Statistical utility methods for simulations.
  module Statistics
    def gaussian
      u1 = [rand, Float::MIN].max
      u2 = rand
      Math.sqrt(-2.0 * Math.log(u1)) *
        Math.cos(2.0 * Math::PI * u2)
    end

    def percentile(sorted, pct)
      values = Array(sorted).compact.select do |n|
        n.respond_to?(:finite?) && n.finite?
      end
      return 0.0 if values.empty?

      clamped_pct = [[pct.to_f, 0.0].max, 100.0].min
      idx = (clamped_pct / 100.0 * values.length).ceil - 1
      values[[idx, 0].max].round(2)
    end
  end
end
