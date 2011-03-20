require 'osheet/dsl/cell'

module Osheet::Dsl
  class Row

    def initialize(&block)
      @cells = []
      instance_eval(&block) if block
    end

    def cell(&block); @cells << Cell.new(&block); end

  end
end
