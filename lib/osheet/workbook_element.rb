module Osheet::WorkbookElement

  def workbook
    get_ivar(:workbook)
  end

  [:styles, :templates].each do |thing|
    define_method(thing) do
      if workbook && workbook.respond_to?(thing)
        workbook.send(thing)
      else
        nil
      end
    end
  end

end
