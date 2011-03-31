require 'date'

module Osheet
  class Cell
    include WorkbookElement
    include WorksheetElement
    include StyledElement

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      @workbook = workbook
      @worksheet = worksheet
      @data = nil
      @format = nil
      @rowspan = 1
      @colspan = 1
      @href = nil
      instance_exec(*args, &block) if block_given?
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

    def attributes
      {
        :style_class => @style_class,
        :data => @data,
        :format => @format,
        :colspan => @colspan,
        :rowspan => @rowspan,
        :href => @href,
      }
    end

  end
end
