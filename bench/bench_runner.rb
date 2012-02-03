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

    @memory_usage  = {
      :prev => 0,
      :curr => 0
    }
  end

  def user=(value_in_secs);   @user   = value_in_secs.to_f * 1000; end
  def system=(value_in_secs); @system = value_in_secs.to_f * 1000; end
  def total=(value_in_secs);  @total  = value_in_secs.to_f * 1000; end
  def real=(value_in_secs);   @real   = value_in_secs.to_f * 1000; end

  def measure(&block)
    Benchmark.measure(&block).to_s.strip.gsub(/[^\s|0-9|\.]/, '').split(/\s+/).tap do |values|
      self.user, self.system, self.total, self.real = values
    end
  end

  def snapshot_memory_usage
    @memory_usage[:prev] = @memory_usage[:curr]
    @memory_usage[:curr] = current_memory_usage
  end

  def to_s(meas, label)
    if meas == :memory
      "#{label_s(label)}:  #{memory_s(@memory_usage[:curr])} MB  #{"(#{memory_basis_s})"}"
    else
      "#{label_s(label)}:  #{time_s(meas)} ms"
    end
  end

  protected

  def current_memory_usage
    # capture memory usage of current process in MB
    (a = ((`ps -o rss= -p #{$$}`.to_i) / 1000)) <= 0 ? 1 : a
  end

  def label_s(label); label.rjust(15); end
  def time_s(meas); self.send(meas).to_s.rjust(10); end
  def memory_s(amount)
    amount.to_s.rjust(4)
  end
  def perc_s(perc)
    (perc*100).round.abs.to_s.rjust(3)
  end

  def memory_basis_s
    if @memory_usage[:prev] == 0
      "??"
    else
      diff = (@memory_usage[:curr] - @memory_usage[:prev])
      perc = diff.to_f / @memory_usage[:prev].to_f

      if diff > 0
        ANSI.red   + "+#{memory_s(diff.abs)} MB, #{perc_s(perc)}%" + ANSI.reset
      else
        ANSI.green + "-#{memory_s(diff.abs)} MB, #{perc_s(perc)}%" + ANSI.reset
      end
    end
  end

end

class OsheetRowsResults < OsheetBenchResults

  def initialize(row_count)
    @scope = self
    super("#{row_count} rows")
    snapshot_memory_usage
    puts self.to_s(:memory, "memory @ init")

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

          10.times do |i|
            (row_count / 10).times do
              row :data, data_values
            end
            @scope.snapshot_memory_usage
            puts @scope.to_s(:memory, "memory @ #{((i+1)*10).to_s.rjust(3)}%")
          end
        }
      }.to_data(:pp => 2)
    end
    snapshot_memory_usage
    puts self.to_s(:memory, "memory @  end")
    puts self.to_s(:real, "real exec time")
  end

end

class OsheetBenchRunner

  ROWS = [10, 100, 1000, 10000]#, 30000]

  def initialize
    puts "Benchmark Results:"
    puts
    ROWS.each do |size|
      puts "#{size } rows"
      puts '-'*(size.to_s.length+1+4)
      OsheetRowsResults.new(size)
      puts
    end
    puts
  end

end

