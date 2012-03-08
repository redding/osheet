require 'osheet/meta_element'
require 'osheet/column'
require 'osheet/row'

# this class is collects and validates worksheet meta-data.  It allows
# for storing a set of columns for referencing when building rows.  It is
# up to the writer to take this data and use it as needed.

module Osheet
  class Worksheet

    include MetaElement

    attr_reader :columns, :rows

    def initialize(name=nil, *args)
      @name = name
      @columns = []
      @rows = []
    end

    def name(value=nil)
      value.nil? ? @name : @name = value.to_s
    end

    def column(column_obj)
      @columns << column_obj
    end

    # Osheet only stores the latest row in memory for reference
    # memory bloat would be unmanageable in large spreadsheets if
    # all rows were stored
    def row(row_obj)
      @rows.pop
      @rows << row_obj
    end

    private

    # TODO: move this check to the writer
    # def sanitized_name(name_value)
    #   # if get_ivar(:workbook) && get_ivar(:workbook).worksheets.collect{|ws| ws.name}.include?(name_value)
    #   #   raise ArgumentError, "the sheet name '#{name_value}' is already in use.  choose a sheet name that is not used by another sheet"
    #   # end
    # end

  end
end
