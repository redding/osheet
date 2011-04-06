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
        data 1000
        format :number, {
          :decimal_places => 4,
          :comma_separator => true
        }
      }
    }
  }
}.to_file('examples/basic.xls')