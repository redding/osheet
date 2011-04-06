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



}.to_file('examples/formats.xls')