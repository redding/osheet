require 'osheet/cell'

module Osheet
  class Row
    include StyledElement
    include WorksheetElement
    include Associations

    hm :cells

    def initialize(worksheet=nil, &block)
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
