require 'osheet/style'

module Osheet; end
class Osheet::Workbook; end

module Osheet
  class Workbook::StyleSet < ::Array

    # this class is an Array with some helper methods.  I want to
    # push styles into the set using the '<<' operator, only allow
    # Osheet::Style objs to be pushed, and then be able to reference
    # a particular set of styles using a style class.

    def initialize
      super
    end

    def <<(value)
      super if verify(value)
    end

    # return the style set for the style class
    def for(style_class)
      self.select{|s| s.match?(style_class)}
    end

    private

    # verify the style, otherwise ArgumentError it up
    def verify(style)
      if style.kind_of?(Style)
        true
      else
        raise ArgumentError, 'you can only push Osheet::Style objs to the style set'
      end
    end

  end
end
