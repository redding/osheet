# To run:
# $ bundle install
# $ bundle exec ruby examples/basic_with_templates.rb
# $ open examples/basic_with_templates.xls

require 'rubygems'
require 'osheet'

fields = ['Sex', 'Age', 'Height', 'Weight']
data = {
  'Tom' => ['M', 52, "6'2\"", '220 lbs.'],
  'Dick' => ['M', 33, "6'5\"", '243 lbs.'],
  'Sally' => ['F', 29, "5'3\"", '132 lbs.']
}

# this will dump the above data to a single-sheet workbook w/ no styles


Osheet::Workbook.new {
  title "basic"

  template(:column, :data) { |field, index|
    width 80
    meta(
      :label => field.to_s,
      :index => index
    )
  }

  template(:row, :title) {
    cell {
      colspan columns.count
      data worksheet.name
    }
  }

  template(:row, :empty) {
    cell {
      colspan columns.count
      data ''
    }
  }

  template(:row, :header) {
    columns.each do |column|
      cell {
        data column.meta[:label]
      }
    end
  }

  template(:row, :data) { |name, stats|
    cell {
      data name
    }
    stats.each do |stat|
      cell {
        data stat
      }
    end
  }

  worksheet {
    name "Stats: #{fields.join(', ')}"

    column {
      width 200
      meta(
        :label => "Name"
      )
    }
    fields.each_with_index do |f, i|
      column :data, f, i
    end

    row :title
    row :empty
    row :header

    data.each do |name, stats|
      row :data, name, stats
    end
  }
}.to_file('examples/basic_with_templates.xls', :format)