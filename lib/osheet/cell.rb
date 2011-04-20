require 'date'
require 'osheet/format'

module Osheet
  class Cell
    include Instance
    include WorkbookElement
    include WorksheetElement
    include StyledElement
    include MarkupElement

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      set_ivar(:workbook, workbook)
      set_ivar(:worksheet, worksheet)
      set_ivar(:data, nil)
      set_ivar(:format, Format.new(:general))
      set_ivar(:rowspan, 1)
      set_ivar(:colspan, 1)
      set_ivar(:href, nil)
      if block_given?
        set_binding_ivars(block.binding)
        instance_exec(*args, &block)
      end
    end

    def data(value)
      set_ivar(:data, case value
      when ::String, ::Numeric, ::Date, ::Time, ::DateTime
        value
      when ::Symbol
        value.to_s
      else
        value.inspect.to_s
      end)
    end

    def format(type, opts={})
      set_ivar(:format, Format.new(type, opts))
    end

    def rowspan(value); set_ivar(:rowspan, value); end
    def colspan(value); set_ivar(:colspan, value); end
    def href(value); set_ivar(:href, value); end

    def attributes
      {
        :style_class => get_ivar(:style_class),
        :data => get_ivar(:data),
        :format => get_ivar(:format),
        :colspan => get_ivar(:colspan),
        :rowspan => get_ivar(:rowspan),
        :href => get_ivar(:href)
      }
    end

  end
end
