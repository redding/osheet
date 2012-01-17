require 'date'

require 'osheet/format'
require 'osheet/meta_element'
require 'osheet/styled_element'

module Osheet
  class Cell

    include MetaElement
    include StyledElement

    def initialize(data=nil)
      @data = data
      @format = Format.new(:general)
      @rowspan = 1
      @colspan = 1
      @index = nil
      @href = nil
      @formula = nil
    end

    def data(value=nil)
      value.nil? ? @data : @data = cast_data_value(value)
    end

    def format(value=nil, opts={})
      value.nil? ? @format : @format = Format.new(value, opts)
    end

    def rowspan(value=nil)
      value.nil? ? @rowspan : @rowspan = value
    end

    def colspan(value=nil)
      value.nil? ? @colspan : @colspan = value
    end

    def index(value=nil)
      value.nil? ? @index : @index = value
    end

    def href(value=nil)
      value.nil? ? @href : @href = value
    end

    def formula(value=nil)
      value.nil? ? @formula : @formula = value
    end

    private

    def cast_data_value(value)
      case value
      when ::String, ::Numeric, ::Date, ::Time, ::DateTime
        value
      when ::Symbol
        value.to_s
      else
        value.inspect.to_s
      end
    end

  end
end
