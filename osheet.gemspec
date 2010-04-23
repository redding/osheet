# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osheet}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Redding"]
  s.date = %q{2010-04-23}
  s.email = %q{kelly@kelredd.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/osheet", "lib/osheet/base.rb", "lib/osheet/cell.rb", "lib/osheet/column.rb", "lib/osheet/row.rb", "lib/osheet/version.rb", "lib/osheet/workbook.rb", "lib/osheet/worksheet.rb", "lib/osheet.rb"]
  s.homepage = %q{http://github.com/kelredd/osheet}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A DSL for generating spreadsheets that doesn't totally suck - pronounced 'Oh sheeeeeet!'}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 2.10.0"])
      s.add_development_dependency(%q<kelredd-useful>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<spreadsheet>, [">= 0.6.4"])
    else
      s.add_dependency(%q<shoulda>, [">= 2.10.0"])
      s.add_dependency(%q<kelredd-useful>, [">= 0.3.0"])
      s.add_dependency(%q<spreadsheet>, [">= 0.6.4"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 2.10.0"])
    s.add_dependency(%q<kelredd-useful>, [">= 0.3.0"])
    s.add_dependency(%q<spreadsheet>, [">= 0.6.4"])
  end
end
