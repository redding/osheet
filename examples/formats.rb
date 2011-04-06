# To run:
# $ gem install osheet
# $ ruby examples/formats.rb
# $ open examples/formats.xls

require 'rubygems'
require 'osheet'

Osheet::Workbook.new {
  title "formats"
  worksheet {
    name "number"
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
}.to_file('examples/formats.xls')