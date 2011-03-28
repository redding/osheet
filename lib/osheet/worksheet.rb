require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet
    include Associations
    include WorkbookElement

    hm :columns
    hm :rows

    def initialize(workbook=nil, *args, &block)
      @workbook = workbook
      @name = nil
      instance_exec(*args, &block) if block_given?
    end

    def name(value); @name = value; end

  end
end
