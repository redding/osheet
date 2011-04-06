require 'enumeration'
require 'osheet/format/numeric'

module Osheet::Format

  class Number
    include Enumeration
    include Numeric

    attr_accessor :decimal_places, :comma_separator
    enum :negative_numbers, [:black, :black_parenth, :red, :red_parenth]

    def initialize(opts={})
      self.decimal_places = opts[:decimal_places] || 0
      self.comma_separator = opts.has_key?(:comma_separator) ? opts[:comma_separator] : false
      self.negative_numbers = opts[:negative_numbers] || :black
    end

    def decimal_places=(value)
      if !value.kind_of?(::Fixnum) || value < 0 || value > 30
        raise ArgumentError, ":decimal_places must be a Fixnum between 0 and 30."
      end
      @decimal_places = value
    end

    def comma_separator=(value)
      @comma_separator = !!value
    end

    def style
      negative_numbers_style
    end

    def key
      "number_#{decimal_places_key}_#{comma_separator_key}_#{negative_numbers_key}"
    end

    private

    def numeric_style
      # used by negative_numbers_style mixed in from Numeric
      "#{comma_separator_style}#{decimal_places_style}"
    end

  end
end
