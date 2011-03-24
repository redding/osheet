module Osheet
  class Column
    include WorkbookElement
    include WorksheetElement
    include StyledElement

    def initialize(workbook=nil, worksheet=nil, &block)
      @workbook = workbook
      @worksheet = worksheet
      @width = nil
      @autofit = false
      @hidden = false
      @meta = nil
      instance_eval(&block) if block
    end

    def width(value); @width = value; end
    def autofit(value); @autofit = !!value; end
    def autofit?; @autofit; end
    def hidden(value); @hidden = !!value; end
    def hidden?; @hidden; end

    def meta(value=nil)
      value.nil? ? @meta : (@meta = value)
    end
  end
end
