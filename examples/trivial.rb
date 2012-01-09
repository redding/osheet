# To run:
# $ bundle install
# $ bundle exec ruby examples/trivial.rb
# $ open examples/trivial.xls

require 'rubygems'
require 'osheet'

puts "building examples/trivial.rb ..."

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
}.to_file('examples/trivial.xls', :pp => 2)

puts "open examples/trivial.xls"
