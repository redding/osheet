module Osheet
  class Column
    include Instance
    include WorkbookElement
    include WorksheetElement
    include StyledElement
    include MetaElement

    def initialize(workbook=nil, worksheet=nil, *args, &block)
      set_ivar(:workbook, workbook)
      set_ivar(:worksheet, worksheet)
      set_ivar(:width, nil)
      set_ivar(:autofit, false)
      set_ivar(:hidden, false)
      if block_given?
        set_binding_ivars(block.binding)
        instance_exec(*args, &block)
      end
    end

    def width(value=nil)
      !value.nil? ? set_ivar(:width, value) : get_ivar(:width)
    end
    def autofit(value); set_ivar(:autofit, !!value); end
    def autofit?; get_ivar(:autofit); end
    def hidden(value); set_ivar(:hidden, !!value); end
    def hidden?; get_ivar(:hidden); end

    def attributes
      {
        :style_class => get_ivar(:style_class),
        :width => get_ivar(:width),
        :autofit => get_ivar(:autofit),
        :hidden => get_ivar(:hidden)
      }
    end

  end
end
