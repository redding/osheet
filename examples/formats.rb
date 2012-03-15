# To run:
# $ bundle install
# $ bundle exec ruby examples/formats.rb
# $ open examples/formats.xls

require 'rubygems'
require 'osheet'

puts "building examples/formats.rb ..."

Osheet::Workbook.new(Osheet::XmlssWriter.new(:pp => 2)) {
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


  # currency/accounting format examples
  worksheet {
    name "currency, accounting"

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

    data_opts = [
      {},
      {
        :symbol => :euro,
        :decimal_places => 0,
        :negative_numbers => :red
      },
      {
        :decimal_places => 1,
        :comma_separator => false,
        :negative_numbers => :black_parenth
      },
      {
        :decimal_places => 8,
        :comma_separator => true,
        :negative_numbers => :red_parenth
      }
    ]

    # currency data rows
    data_opts.each do |opts|
      row {
        cell {
          data Osheet::Format.new(:currency, opts).key
        }
        columns[1..-1].each do |col|
          cell {
            data col.meta[:value]
            format :currency, opts
          }
        end
      }
    end

    # accounting data rows
    data_opts.each do |opts|
      row {
        cell {
          data Osheet::Format.new(:accounting, opts).key
        }
        columns[1..-1].each do |col|
          cell {
            data col.meta[:value]
            format :accounting, opts
          }
        end
      }
    end
  }



  # percentage format examples
  worksheet {
    name "percentage, scientific"

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

    data_opts = [
      {},
      {
        :decimal_places => 0,
        :negative_numbers => :red
      },
      {
        :decimal_places => 1,
        :comma_separator => false,
        :negative_numbers => :black_parenth
      },
      {
        :decimal_places => 8,
        :comma_separator => true,
        :negative_numbers => :red_parenth
      }
    ]

    # percentage data rows
    data_opts.each do |opts|
      row {
        cell {
          data Osheet::Format.new(:percentage, opts).key
        }
        columns[1..-1].each do |col|
          cell {
            data col.meta[:value]
            format :percentage, opts
          }
        end
      }
    end

    # scientific data rows
    data_opts.each do |opts|
      row {
        cell {
          data Osheet::Format.new(:scientific, opts).key
        }
        columns[1..-1].each do |col|
          cell {
            data col.meta[:value]
            format :scientific, opts
          }
        end
      }
    end
  }



  # fraction format examples
  worksheet {
    name "fractions"

    column {
      width 250
      meta(:label => 'Format')
    }
    column {
      width 125
      meta(:label => 'Fraction Example')
    }

    # header row
    row {
      columns.each do |col|
        cell{ data col.meta[:label] }
      end
    }

    # fraction data rows
    data_opts = {
      :one_digit => 0.5,
      :two_digits => 0.0125,
      :three_digits => 0.01,
      :halves => 0.5,
      :quarters => 0.25,
      :eighths => 0.125,
      :sixteenths => 0.0625,
      :tenths => 0.1,
      :hundredths => 0.01
    }
    data_opts.each do |k,v|
      row {
        cell {
          data Osheet::Format.new(:fraction, :type => k).key
        }
        cell {
          data v
          format :fraction, :type => k
        }
      }
    end
  }



  # text format examples
  worksheet {
    name "text, special, custom"

    column {
      width 250
      meta(:label => 'Format')
    }
    column {
      width 125
      meta(:label => 'Result')
    }

    # header row
    row {
      columns.each do |col|
        cell{ data col.meta[:label] }
      end
    }

    # text data row
    row {
      cell {
        data Osheet::Format.new(:text).key
      }
      cell {
        data "001122 blah blah"
        format :text
      }
    }

    # special data rows
    {
      :zip_code => 12345,
      :zip_code_plus_4 => 123456789,
      :phone_number => 5551112222,
      :social_security_number => 333224444
    }.each do |k,v|
      row {
        cell {
          data Osheet::Format.new(:special, :type => k).key
        }
        cell {
          data v
          format :special, :type => k
        }
      }
    end

    # custom data row
    row {
      cell {
        data Osheet::Format.new(:custom, '@').key
      }
      cell {
        data "001122 blah blah"
        format :custom, '@'
      }
    }
  }



  # datetime format examples
  worksheet {
    name "date, time"

    column {
      width 250
      meta(:label => 'Format')
    }
    column {
      width 125
      meta(:label => 'Datetime')
    }

    # header row
    row {
      columns.each do |col|
        cell{ data col.meta[:label] }
      end
    }

    # datetime data row
    [ 'm','d','y', 'mm', 'dd', 'yy', 'yyyy',
      'mm/dd/yy', 'mm/dd/yyyy', 'mmmm', 'mmmmm', 'mmmmm',
      'h','m','s', 'hh', 'mm', 'ss',
      'h:mm:ss', 'h:mm:ss.0', 'hh:mm:ss AM/PM'
    ].each do |s|
      row {
        cell {
          data Osheet::Format.new(:datetime, s).key
        }
        cell {
          data Date.today
          format :datetime, s
        }
      }
    end
  }



}.to_file('examples/formats.xls')

puts "open examples/formats.xls"
