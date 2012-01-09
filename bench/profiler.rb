# $ bundle exec ruby bench/profiler.rb

require 'bench/profiler_runner'

runner = OsheetProfilerRunner.new(ARGV[0] ? ARGV[0].to_i : 1000)
runner.print_flat(STDOUT, :min_percent => 1)
