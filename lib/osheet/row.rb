require 'osheet/cell'

module Osheet
  class Row
    include Associations
    include WorkbookElement
    include WorksheetElement
    include StyledElement
    include MetaElement

    hm :cells

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      @workbook = workbook
      @worksheet = worksheet
      @height = nil
      @autofit = false
      @hidden = false
      instance_exec(*args, &block) if block_given?
    end

    def height(value=nil)
      !value.nil? ? @height = value : @height
    end
    def autofit(value); @autofit = !!value; end
    def autofit?; @autofit; end
    def hidden(value); @hidden = !!value; end
    def hidden?; @hidden; end

    def attributes
      {
        :style_class => @style_class,
        :height => @height,
        :autofit => @autofit,
        :hidden => @hidden
      }
    end

  end
end
