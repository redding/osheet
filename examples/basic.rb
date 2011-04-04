# To run:
# $ gem install osheet
# $ ruby examples/basic.rb
# $ open examples/basic.xls

require 'rubygems'
require 'osheet'

Osheet::Workbook.new {
  title "basic"
  worksheet {
    name "one dollar"
    column
    row {
      cell {
        data 1
        format "Currency"
      }
    }
  }
}.to_file('examples/basic.xls')