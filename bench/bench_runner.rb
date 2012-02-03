require 'benchmark'
require 'stringio'
require 'ansi'

require 'osheet'

class OsheetBenchResults

  attr_reader :user, :system, :total, :real
  attr_accessor :label, :out, :outstream

  def initialize(label)
    @label = label.to_s
    @user, @system, @total, @real = 0
    @outstream = StringIO.new(@out = "")
  end

  def user=(value_in_secs);   @user   = value_in_secs.to_f * 1000; end
  def system=(value_in_secs); @system = value_in_secs.to_f * 1000; end
  def total=(value_in_secs);  @total  = value_in_secs.to_f * 1000; end
  def real=(value_in_secs);   @real   = value_in_secs.to_f * 1000; end

  def to_s(meas=:real, basis=nil)
    "#{label_s}:  #{time_s(meas)} ms  #{"(#{basis_s(meas, basis)})" if basis}"
  end

  protected

  def measure(&block)
    Benchmark.measure(&block).to_s.strip.gsub(/[^\s|0-9|\.]/, '').split(/\s+/).tap do |values|
      self.user, self.system, self.total, self.real = values
    end
  end

  def label_s; @label.rjust(10); end
  def time_s(meas); self.send(meas).to_s.rjust(10); end

  def basis_s(meas, time)
    diff = (time - self.send(meas))
    perc = ((diff / time) * 100).round
    if diff >= 0
      ANSI.green + "+#{diff} ms, +#{perc}%" + ANSI.reset
    else
      ANSI.red + "#{diff} ms, #{perc}%" + ANSI.reset
    end
  end

end

class OsheetRowsResults < OsheetBenchResults

  def initialize(row_count)
    super("#{row_count} rows")
    measure do
      data_values = {
        :number   => 1,
        :text     => 'text',
        :currency => 123.45,
        :text     => "<>&'\"/",
        :currency => 45.23
      }

      @outstream << Osheet::Workbook.new {
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

          row_count.times do
            row :data, data_values
          end
        }
      }.to_data(:pp => 2)
    end
  end

end

class OsheetBenchRunner

  ROWS = [10, 100, 1000, 10000, 30000]

  def initialize
    puts "Benchmark Results:"
    puts
    ROWS.each do |size|
      puts OsheetRowsResults.new(size)
    end
    puts
  end

end

