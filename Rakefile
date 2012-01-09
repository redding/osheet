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

