# To run:
# $ bundle install
# $ bundle exec ruby examples/trivial.rb
# $ open examples/trivial.xls

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
        format :currency
      }
    }
  }
}.to_file('examples/trivial.xls', :format)