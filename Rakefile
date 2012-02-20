require 'assert/rake_tasks'
include Assert::RakeTasks

require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :build

namespace :bench do

  desc "Run the bench script."
  task :run do
    require 'bench/bench_runner'
    OsheetBenchRunner.new
  end

  desc "Run the profiler on 1000 rows."
  task :profiler do
    require 'bench/profiler_runner'
    runner = OsheetProfilerRunner.new(1000)
    runner.print_flat(STDOUT, :min_percent => 3)
  end

  desc "Run the example workbook builds."
  task :examples do
    require 'examples/trivial'
    require 'examples/basic'
    require 'examples/basic_with_templates'
    require 'examples/formats'
    require 'examples/formula'
    require 'examples/styles'
  end

  desc "Run all the tests, then the example builds, then the profiler."
  task :all do
    Rake::Task['test'].invoke
    Rake::Task['bench:run'].invoke
    Rake::Task['bench:profiler'].invoke
    Rake::Task['bench:examples'].invoke
  end


end

task :bench do
  Rake::Task['bench:run'].invoke
end

