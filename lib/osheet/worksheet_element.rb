module Osheet::WorksheetElement
  class << self
    def included(receiver)
      receiver.send(:attr_reader, :worksheet)
    end
  end

  def columns
    if worksheet && worksheet.respond_to?(:columns)
      worksheet.columns
    else
      nil
    end
  end
end
