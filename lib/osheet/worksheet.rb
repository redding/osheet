require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet
    include Associations

    hm :columns
    hm :rows

    def initialize(&block)
      @name = nil
      instance_eval(&block) if block
    end

    def name(value); @name = value; end

  end
end
