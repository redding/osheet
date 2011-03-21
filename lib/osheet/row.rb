require 'osheet/cell'

module Osheet
  class Row
    include StyledElement

    def initialize(&block)
      @height = nil
      @autofit = false
      @hidden = false

      @cells = []

      instance_eval(&block) if block
    end

    def height(value); @height = value; end
    def autofit(value); @autofit = !!value; end
    def autofit?; @autofit; end
    def hidden(value); @hidden = !!value; end
    def hidden?; @hidden; end

    def cell(&block); @cells << Cell.new(&block); end

  end
end
