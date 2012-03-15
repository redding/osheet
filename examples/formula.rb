# To run:
# $ bundle install
# $ bundle exec ruby examples/formula.rb
# $ open examples/formula.xls

require 'rubygems'
require 'osheet'


# this will dump the above data to a single-sheet workbook w/ no styles

puts "building examples/formula.rb ..."

Osheet::Workbook.new(Osheet::XmlssWriter.new(:pp => 2)) {
  title "formula example"
  worksheet {
    name "Formula"
    row {
      cell { data 1 }
      cell { data 2 }
      # please note formulas use R1C1 notation
      # check out for example http://www.bettersolutions.com/excel/EED883/YI416010881.htm
      # this is absolute reference, ie. =$A$1+$B$1
      cell { formula "=R1C1+R1C2" }
    }
  }
  worksheet {
    name "Refers to previous sheet"
    row {
      cell { data 3 }
      cell { data 4 }
      cell {
        # you can still refer to cells in other sheets through the name of the sheet and !
        # this is also a relative reference, ie. =Formula!A1+B2
        formula "=Formula!RC[-2]+RC[-1]"
        # 6 will change into 5 when formula gets recalculated
        data 6
      }
    }
  }
}.to_file('examples/formula.xls')

puts "open examples/formula.xls"
