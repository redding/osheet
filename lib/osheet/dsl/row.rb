require 'osheet/base'
require 'osheet/cell'

module Osheet::Dsl
  class Row < Osheet::Dsl::Base

    defaults(
      :cells => []
    )

    def cell(&block); @cells << Cell.new(&block); end

  end
end
