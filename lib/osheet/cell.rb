require 'date'

module Osheet
  class Cell
    include StyledElement
    include WorksheetElement

    def initialize(row_or_worksheet=nil, &block)
      @worksheet = if row_or_worksheet.kind_of?(Worksheet)
        row_or_worksheet
      elsif row_or_worksheet.respond_to?(:worksheet)
        row_or_worksheet.worksheet
      end
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
