module Osheet::WorkbookElement
  class << self

    def included(receiver)

      receiver.send(:attr_reader, :workbook)

      [:styles, :templates].each do |thing|
        receiver.send(:define_method, thing) do
          if workbook && workbook.respond_to?(thing)
            workbook.send(thing)
          else
            nil
          end
        end
      end

    end

  end
end
