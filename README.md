=== **This has been archived and is not maintained.** ===

#  Osheet

## Description

A DSL for specifying and generating spreadsheets using Ruby.

## Simple Usage Example

This example uses the Xmlss writer provided by Osheet::Xmlss (https://github.com/kellyredding/osheet-xmlss).

```ruby
require 'osheet'
require 'osheet/xmlss'

fields = ['Sex', 'Age', 'Height', 'Weight']
data = {
  'Tom' => ['M', 52, "6'2\"", '220 lbs.'],
  'Dick' => ['M', 33, "6'5\"", '243 lbs.'],
  'Sally' => ['F', 29, "5'3\"", '132 lbs.']
}

# this will dump the above data to a single-sheet workbook w/ no styles
# - this example is using the Xmlss writer (https://github.com/kellyredding/xmlss)

Osheet::Workbook.new(Osheet::XmlssWriter.new) {
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
}.to_file('stats.xls')
```

## API

Check out the wiki: https://github.com/kelredd/osheet/wiki.  It covers the full Osheet API.

## Examples

I've added a few examples to ./examples.  Please refer first to the API then to these for examples on basic usage, using templates, formatting data, and styling data.

## Links

* *Osheet*
  - http://github.com/kelredd/osheet

* *Wiki*
  - https://github.com/kelredd/osheet/wiki

## Installation

Add this line to your application's Gemfile:

    gem 'osheet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install osheet

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
