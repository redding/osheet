module Osheet::WorksheetElement
  class << self
    def included(receiver)
      receiver.send(:attr_reader, :worksheet)
    end
  end

  [:columns, :rows].each do |meth|
    define_method(meth) do
      if worksheet && worksheet.respond_to?(meth)
        worksheet.send(meth)
      else
        nil
      end
    end
  end

end
