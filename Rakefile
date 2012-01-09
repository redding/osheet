require 'assert/rake_tasks'
include Assert::RakeTasks

require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :build

desc "Run the example workbook builds."
task :run_examples do
  require 'examples/trivial'
  require 'examples/basic'
  require 'examples/basic_with_templates'
  require 'examples/formats'
  require 'examples/formula'
  require 'examples/styles'
end

desc "Run the profiler on 1000 rows."
task :run_profiler do
  require 'bench/profiler_runner'

  runner = OsheetProfilerRunner.new(1000)
  runner.print_flat(STDOUT, :min_percent => 3)
end

desc "Run all the tests, then the example builds, then the profiler."
task :run_all do
  Rake::Task['test'].invoke
  Rake::Task['run_examples'].invoke
  Rake::Task['run_profiler'].invoke
end
