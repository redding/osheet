module Osheet::Format

  class Datetime

    def initialize(string)
      @string = string
    end

    def style; @string; end
    def key; "datetime_#{@string}"; end

  end
end
