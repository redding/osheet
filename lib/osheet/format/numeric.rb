module Osheet::Format
  module Numeric


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
        '"$"'
      when :euro
        "[$€-2]\ "
      when :none
        ''
      end
    end
    def symbol_key
      @symbol.to_s.gsub('_', '')
    end
  end
end
