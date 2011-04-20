require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet
    include Instance
    include Associations
    include WorkbookElement
    include MetaElement
    include MarkupElement

    hm :columns
    hm :rows

    def initialize(workbook=nil, *args, &block)
      set_ivar(:workbook, workbook)
      set_ivar(:name, nil)
      if block_given?
        set_binding_ivars(block.binding)
        instance_exec(*args, &block)
      end
    end

    def name(value=nil)
      !value.nil? ? set_ivar(:name, sanitized_name(value)) : get_ivar(:name)
    end

    def attributes
      { :name => get_ivar(:name) }
    end

    private

    def sanitized_name(name_value)
      if get_ivar(:workbook) && get_ivar(:workbook).worksheets.collect{|ws| ws.name}.include?(name_value)
        raise ArgumentError, "the sheet name '#{name_value}' is already in use.  choose a sheet name that is not used by another sheet"
      end
      name_value
    end

  end
end
