module Osheet::WorksheetElement
  def worksheet
    get_ivar(:worksheet)
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
