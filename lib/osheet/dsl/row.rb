require 'osheet/dsl/base'
require 'osheet/dsl/cell'

module Osheet::Dsl
  class Row < Osheet::Dsl::Base

    defaults(
      :cells => []
    )

    def cell(&block); self.cells_set << Cell.new(&block); end

  end
end
