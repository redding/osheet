require 'osheet/base'
require 'osheet/column'
require 'osheet/row'

module Osheet::Dsl
  class Worksheet < Osheet::Dsl::Base

    defaults(
      :name => nil,
      :rows => [],
      :columns => []
    )

    def name(name); @name = name; end
    def row(&block); @rows << Row.new(&block); end
    def column(&block); @columns << Column.new(&block); end

  end
end
