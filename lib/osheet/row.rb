require 'osheet/cell'

module Osheet
  class Row
    include Associations
    include WorkbookElement
    include WorksheetElement
    include StyledElement

    hm :cells

    def initialize(workbook=nil, worksheet=nil, &block)
      @workbook = workbook
      @worksheet = worksheet
      @height = nil
      @autofit = false
      @hidden = false
      instance_eval(&block) if block
    end

    def height(value); @height = value; end
    def autofit(value); @autofit = !!value; end
    def autofit?; @autofit; end
    def hidden(value); @hidden = !!value; end
    def hidden?; @hidden; end

  end
end
