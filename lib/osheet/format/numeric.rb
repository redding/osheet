require 'enumeration'

module Osheet::Format

  class Numeric
    include Enumeration

    attr_accessor :decimal_places, :comma_separator
    enum :symbol, [:none, :dollar, :euro]
    enum :negative_numbers, [:black, :black_parenth, :red, :red_parenth]

    def initialize(opts={})
      self.symbol = opts[:symbol] || :none
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
      "#{key_prefix}_#{symbol_key}_#{decimal_places_key}_#{comma_separator_key}_#{negative_numbers_key}"
    end

    protected

    # used by 'key' in Numeric base class, override as necessary
    def key_prefix
      "number"
    end

    # used by 'numeric_style' in Numeric base class, override as necessary
    def symbol_suffix
      ""
    end

    private


    def numeric_style
      "#{symbol_style}#{comma_separator_style}#{decimal_places_style}"
    end


    def negative_numbers_style
      case @negative_numbers
      when :black
        numeric_style
      when :red
        "#{numeric_style};[Red]#{numeric_style}"
      when :black_parenth
        "#{numeric_style}_);\(#{numeric_style}\)"
      when :red_parenth
        "#{numeric_style}_);[Red]\(#{numeric_style}\)"
      end
    end
    def negative_numbers_key
      @negative_numbers.to_s.gsub('_', '')
    end


    def decimal_places_style
      "0#{'.'+'0'*@decimal_places if @decimal_places > 0}"
    end
    def decimal_places_key
      @decimal_places.to_s
    end


    def comma_separator_style
      @comma_separator == true ? '#,##' : ''
    end
    def comma_separator_key
      @comma_separator == true ? 'comma' : 'nocomma'
    end


    def symbol_style
      case @symbol
      when :dollar
        "\"$\"#{symbol_suffix}"
      when :euro
        "[$€-2]\ #{symbol_suffix}"
      when :none
        ''
      end
    end
    def symbol_key
      @symbol.to_s.gsub('_', '')
    end

  end
end
