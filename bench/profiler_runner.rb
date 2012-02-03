require 'ruby-prof'
require 'osheet'

class OsheetProfilerRunner

  attr_reader :result

  def initialize(n)

    RubyProf.measure_mode = RubyProf::MEMORY
    @result = RubyProf.profile do
      Osheet::Workbook.new {
        title "basic"
        worksheet {
          name "one dollar"
          5.times { column }

          1000.times do
            row {
              [1, "text", 123.45, "0001267", "$45.23"].each do |data_value|
                cell { data data_value }
              end
            }
          end
        }
      }.to_file('./bench/profiler_1000.xls', :pp => 2)
    end

  end

  def print_flat(outstream, opts={})
    RubyProf::FlatPrinter.new(@result).print(outstream, opts)
    #RubyProf::GraphPrinter.new(@result).print(outstream, opts)
  end

  def print_graph(outstream, opts={})
    RubyProf::GraphPrinter.new(@result).print(outstream, opts)
  end

end
