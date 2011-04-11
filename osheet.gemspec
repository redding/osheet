# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "osheet/version"

Gem::Specification.new do |s|
  s.name        = "osheet"
  s.version     = Osheet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kelly Redding"]
  s.email       = ["kelly@kelredd.com"]
  s.homepage    = "http://github.com/kelredd/osheet"
  s.summary     = %q{A DSL for generating spreadsheets that doesn't totally suck - pronounced 'Oh sheeeeeet!'}
  s.description = %q{A DSL for specifying and generating rich spreasheetML.  Specify your spreadsheet using the richness of Ruby and easily produce the corresponding spreadsheetML to render in MS Excel.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("bundler", ["~> 1.0"])
  s.add_development_dependency("test-belt", ["= 0.2.1"]) # locked to a specific version for test stability

  s.add_dependency("enumeration", ["~>1.1.0"])
  s.add_dependency("xmlss", "~>0.1.0")

end
