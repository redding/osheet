require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet
    include Associations
    include WorkbookElement

    hm :columns
    hm :rows

    def initialize(workbook=nil, &block)
      @workbook = workbook
      @name = nil
      instance_eval(&block) if block
    end

    def name(value); @name = value; end

  end
end
