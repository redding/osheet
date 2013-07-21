require 'osheet/meta_element'
require 'osheet/styled_element'
require 'osheet/cell'

module Osheet
  class Row

    include MetaElement
    include StyledElement

    attr_reader :cells, :format

    def initialize(height=nil)
      @height  = height
      @autofit = false
      @hidden  = false
      @cells   = []
      @format  = Format.new(:general)
    end

    def height(value=nil)
      value.nil? ? @height : @height = value
    end

    def autofit(value=nil)
      value.nil? ? @autofit : @autofit = !!value
    end
    def autofit?; @autofit; end

    def hidden(value=nil)
      value.nil? ? @hidden : @hidden = !!value
    end
    def hidden?; @hidden; end

    def cell(cell_obj)
      @cells << cell_obj
    end

  end
end
