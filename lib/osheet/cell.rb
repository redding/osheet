require 'date'

module Osheet
  class Cell
    include StyledElement

    def initialize(&block)
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
