module Osheet
  class Column
    include WorkbookElement
    include WorksheetElement
    include StyledElement
    include MetaElement

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      @workbook = workbook
      @worksheet = worksheet
      @width = nil
      @autofit = false
      @hidden = false
      instance_exec(*args, &block) if block_given?
    end

    def width(value=nil)
      !value.nil? ? @width = value : @width
    end
    def autofit(value); @autofit = !!value; end
    def autofit?; @autofit; end
    def hidden(value); @hidden = !!value; end
    def hidden?; @hidden; end

    def attributes
      {
        :style_class => @style_class,
        :width => @width,
        :autofit => @autofit,
        :hidden => @hidden
      }
    end

  end
end
