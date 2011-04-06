module Osheet::Format

  class Custom

    def initialize(type)
      @type = type
    end

    def style; @type; end
    def key; "custom_#{@type}"; end

  end
end
