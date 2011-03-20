require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet

    def initialize(&block)
      @name = nil
      @rows = []
      @columns = []
      instance_eval(&block) if block
    end

    def name(value); @name = value; end
    def row(&block); @rows << Row.new(&block); end
    def column(&block); @columns << Column.new(&block); end

  end
end
