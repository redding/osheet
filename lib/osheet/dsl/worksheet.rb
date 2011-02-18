require 'osheet/dsl/base'
require 'osheet/dsl/column'
require 'osheet/dsl/row'

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
