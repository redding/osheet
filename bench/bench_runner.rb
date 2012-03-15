require 'whysoslow'
require 'stringio'

require 'osheet'

class OsheetBenchResults

  def initialize(row_count)
    @row_count = row_count
    @printer = Whysoslow::DefaultPrinter.new({
      :title => "#{@row_count} rows",
      :verbose => true
    })
    @runner = Whysoslow::Runner.new(@printer)
  end

  def run
    @runner.run do
      data_values = {
        :number   => 1,
        :text     => 'text',
        :currency => 123.45,
        :text     => "<>&'\"/",
        :currency => 45.23
      }

      outstream = StringIO.new(out = "")
      outstream << Osheet::Workbook.new(Osheet::XmlssWriter.new(:pp => 2), {
        :bench_row_count => @row_count,
        :runner => @runner
      }) {
        title "bench"

        template(:row, :header) {
          columns.each do |column|
            cell {
              data column.meta[:label]
            }
          end
        }

        template(:row, :data) { |values|
          columns.each do |col|
            cell {
              data values[col.meta[:label]]
              format col.meta[:label]
            }
          end
        }

        worksheet {
          name "bench results"

          data_values.keys.each do |label|
            column {
              width 200
              meta(:label => label)
            }
          end

          row :header

          10.times do |i|
            (bench_row_count / 10).times do
              row :data, data_values
            end
            runner.snapshot("#{((i+1)*10).to_s.rjust(3)}%")
          end
        }
      }.to_data
    end
  end

end

class OsheetBenchRunner

  ROWS = [10, 100, 1000, 10000]#, 30000]

  def initialize
    puts "Benchmark Results:"
    puts
    ROWS.each do |size|
      OsheetBenchResults.new(size).run
      puts
    end
    puts
  end

end

