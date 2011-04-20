module Osheet
  module MarkupElement

    # markup elements can add partial markup to themselves
    def add(partial_name, *args)
      if self.kind_of?(Workbook)
        # on: workbook
        if (partial = self.partials.get(partial_name))
          # add partial
          instance_exec(*args, &partial)
        end
      else
        # on: worksheet, column, row
        if self.workbook && (partial = self.workbook.partials.get(partial_name))
          # add partial
          instance_exec(*args, &partial)
        end
      end
    end

  end
end
