require 'osheet/worksheet'

module Osheet; end
class Osheet::Workbook; end

module Osheet
  class Workbook::WorksheetSet < ::Array

    # this class is just a wrapper to Array.  I want to push worksheets
    # into the set using the '<<' operator, but only allow Worksheet objs
    # to be pushed.

    def initialize
      super
    end

    def <<(value)
      super if verify(value)
    end

    private

    # verify the worksheet, otherwise ArgumentError it up
    def verify(worksheet)
      if worksheet.kind_of?(Worksheet)
        true
      else
        raise ArgumentError, 'can only push Osheet::Worksheet to the set'
      end
    end

  end
end
