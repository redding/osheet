module Osheet::XmlssWriter::Elements

  protected

  def worksheets(oworksheets)
    oworksheets.collect do |oworksheet|
      worksheet(oworksheet)
    end
  end
  def worksheet(oworksheet)
    ::Xmlss::Worksheet.new(oworksheet.attributes[:name], {
      :table => table(oworksheet)
    })
  end
  def table(oworksheet)
    ::Xmlss::Table.new({
      :columns => columns(oworksheet.columns),
      :rows => rows(oworksheet.rows)
    })
  end

  def columns(ocolumns)
    ocolumns.collect do |ocolumn|
      column(ocolumn)
    end
  end
  def column(ocolumn)
    ::Xmlss::Column.new({
      :style_id => style(ocolumn.attributes[:style_class]).id,
      :width => ocolumn.attributes[:width],
      :auto_fit_width => ocolumn.attributes[:autofit],
      :hidden => ocolumn.attributes[:hidden]
    })
  end

  def rows(orows)
    orows.collect do |orow|
      row(orow)
    end
  end
  def row(orow)
    ::Xmlss::Row.new({
      :style_id => style(orow.attributes[:style_class]).id,
      :height => orow.attributes[:height],
      :auto_fit_height => orow.attributes[:autofit],
      :hidden => orow.attributes[:hidden]
    })
  end

end
