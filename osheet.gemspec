# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "osheet/version"

Gem::Specification.new do |gem|
  gem.name        = "osheet"
  gem.version     = Osheet::VERSION
  gem.authors     = ["Kelly Redding", "Collin Redding"]
  gem.email       = ["kelly@kellyredding.com", "collin.redding@me.com"]
  gem.summary     = %q{A DSL for specifying and generating spreadsheets using Ruby}
  gem.description = %q{A DSL for specifying and generating spreadsheets using Ruby}
  gem.homepage    = "http://github.com/redding/osheet"
  gem.license     = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("assert", ["~> 2.16.1"])

  gem.add_dependency("enumeration", ["~> 1.3.2"])

end
