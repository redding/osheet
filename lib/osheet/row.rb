require 'osheet/base'
require 'osheet/cell'

module Osheet
  class Row < Osheet::Base
    
    has :cells => "Cell"

    def initialize(args={})
      super(args)
    end
    
  end
end
