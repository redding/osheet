require 'osheet/base'
require 'osheet/column'
require 'osheet/row'

# === Usage
#
#   require 'osheet'
#
#   Osheet::Workbook.configure do |book|
#     book.worksheet ...
#     book.worksheet ...
#   end

module Osheet
  class Worksheet < Osheet::Base
    
    attr_reader :name

    needs :workbook
    has :columns => "Column"
    has :rows => "Row"

    def initialize(name=nil, args={})
      @name = name
      super(args)
    end
    
  end
end
