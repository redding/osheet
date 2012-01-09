# To run:
# $ bundle install
# $ bundle exec ruby examples/basic.rb
# $ open examples/basic.xls

require 'rubygems'
require 'osheet'

fields = ['Sex', 'Age', 'Height', 'Weight']
data = {
  'Tom' => ['M', 52, "6'2\"", '220 lbs.'],
  'Dick' => ['M', 33, "6'5\"", '243 lbs.'],
  'Sally' => ['F', 29, "5'3\"", '132 lbs.']
}

# this will dump the above data to a single-sheet workbook w/ no styles

puts "building examples/basic.rb ..."

Osheet::Workbook.new {
  title "basic"
  worksheet {
    name "Stats: #{fields.join(', ')}"

    column {
      width 200
      meta(
        :label => "Name"
      )
    }
    fields.each_with_index do |f, i|
      column {
        width 80
        meta(
          :label => f.to_s,
          :index => i
        )
      }
    end

    row {     # title row
      cell {
        colspan columns.count
        data worksheet.name
      }
    }
    row {     # empty row
      cell {
        colspan columns.count
        data ''
      }
    }
    row {     # header row
      columns.each do |column|
        cell {
          data column.meta[:label]
        }
      end
    }

    data.each do |name, stats|
      row {   # data row
        cell {
          data name
        }
        stats.each do |stat|
          cell {
            data stat
          }
        end
      }
    end
  }
}.to_file('examples/basic.xls')

puts "open examples/basic.xls"

