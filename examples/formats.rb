# To run:
# $ gem install osheet
# $ ruby examples/formats.rb
# $ open examples/formats.xls

require 'rubygems'
require 'osheet'

Osheet::Workbook.new {
  title "formats"



  # number format examples
  worksheet {
    name "number"

    column {
      width 250
      meta(:label => 'Format')
    }
    [1000, -20000].each do |n|
      column {
        width 125
        meta(:label => n.to_s, :value => n)
      }
    end

    # header row
    row {
      columns.each do |col|
        cell{ data col.meta[:label] }
      end
    }

    # data rows
    [
      {},
      {
        :decimal_places => 1,
        :negative_numbers => :red
      },
      {
        :decimal_places => 2,
        :comma_separator => true,
        :negative_numbers => :black_parenth
      },
      {
        :decimal_places => 8,
        :comma_separator => true,
        :negative_numbers => :red_parenth
      }
    ].each do |opts|
      row {
        cell {
          data Osheet::Format.new(:number, opts).key
        }
        columns[1..-1].each do |col|
          cell {
            data col.meta[:value]
            format :number, opts
          }
        end
      }
    end




  }
}.to_file('examples/formats.xls')