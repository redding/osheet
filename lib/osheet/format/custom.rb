module Osheet::Format

  class Custom

    def initialize(style_string)
      @style_string = style_string
    end

    def style; @style_string; end
    def key; "custom_#{@style_string}"; end

  end
end
