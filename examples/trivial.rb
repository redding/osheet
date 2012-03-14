# To run:
# $ bundle install
# $ bundle exec ruby examples/trivial.rb
# $ open examples/trivial.xls

require 'rubygems'
require 'osheet'

puts "building examples/trivial.rb ..."

Osheet::Workbook.new(Osheet::XmlssWriter.new(:pp => 2)) {
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
}.to_file('examples/trivial.xls')

puts "open examples/trivial.xls"
