require 'osheet/cell'

module Osheet
  class Row
    include Instance
    include Associations
    include WorkbookElement
    include WorksheetElement
    include StyledElement
    include MetaElement
    include MarkupElement

    hm :cells

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      set_ivar(:workbook, workbook)
      set_ivar(:worksheet, worksheet)
      set_ivar(:height, nil)
      set_ivar(:autofit, false)
      set_ivar(:hidden, false)
      if block_given?
        set_binding_ivars(block.binding)
        instance_exec(*args, &block)
      end
    end

    def height(value=nil)
      !value.nil? ? set_ivar(:height, value) : get_ivar(:height)
    end
    def autofit(value); set_ivar(:autofit, !!value); end
    def autofit?; get_ivar(:autofit); end
    def hidden(value); set_ivar(:hidden, !!value); end
    def hidden?; get_ivar(:hidden); end

    def attributes
      {
        :style_class => get_ivar(:style_class),
        :height => get_ivar(:height),
        :autofit => get_ivar(:autofit),
        :hidden => get_ivar(:hidden)
      }
    end

  end
end
