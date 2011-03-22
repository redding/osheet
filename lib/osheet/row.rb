require 'osheet/cell'

module Osheet
  class Row
    include StyledElement
    include Associations

    hm :cells

    def initialize(&block)
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