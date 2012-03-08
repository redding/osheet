require 'osheet/meta_element'
require 'osheet/styled_element'

module Osheet
  class Column

    include MetaElement
    include StyledElement

    attr_reader :format

    def initialize(width=nil)
      @width = width
      @autofit = false
      @hidden = false
      @format  = Format.new(:general)
    end

    def width(value=nil)
      value.nil? ? @width : @width = value
    end

    def autofit(value=nil)
      value.nil? ? @autofit : @autofit = !!value
    end
    def autofit?; @autofit; end

    def hidden(value=nil)
      value.nil? ? @hidden : @hidden = !!value
    end
    def hidden?; @hidden; end

  end
end
