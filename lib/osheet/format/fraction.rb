require 'enumeration'

module Osheet::Format

  class Fraction
    include Enumeration

    enum(:type, {
      :one_digit => '?/?',
      :two_digits => '??/??',
      :three_digits => '???/???',
      :halves => '?/2',
      :quarters => '?/4',
      :eigths => '?/8',
      :sixteenths => '??/16',
      :tenths => '?/10',
      :hundredths => '??/100'
    })

    def initialize(opts={})
      self.type = opts[:type] || :two_digits
    end

    def style
      "#\ #{type}"
    end

    def key
      "fraction_#{type_key.to_s.gsub('_', '')}"
    end

  end
end
