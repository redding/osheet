require 'date'

module Osheet
  class Cell
    include WorkbookElement
    include WorksheetElement
    include StyledElement

    def initialize(workbook=nil, worksheet=nil, &block)
      @workbook = workbook
      @worksheet = worksheet#if worksheet_or_row.kind_of?(Worksheet)
      #   worksheet_or_row
      # elsif worksheet_or_row.respond_to?(:worksheet)
      #   worksheet_or_row.worksheet
      # end
      @data = nil
      @format = nil
      @rowspan = 1
      @colspan = 1
      @href = nil
      instance_eval(&block) if block
    end

    def data(value)
      @data = case value
      when ::String, ::Numeric, ::Date, ::Time, ::DateTime
        value
      when ::Symbol
        value.to_s
      else
        value.inspect.to_s
      end
    end

    def format(value)
      @format = if value.respond_to?('to_s')
        value.to_s
      else
        value.inspect.to_s
      end
    end

    def rowspan(value); @rowspan = value; end
    def colspan(value); @colspan = value; end
    def href(value); @href = value; end

  end
end
