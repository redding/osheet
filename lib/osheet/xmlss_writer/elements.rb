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
      :style_id => style_id(ocolumn.attributes[:style_class]),
      :width => ocolumn.attributes[:width],
      :auto_fit_width => ocolumn.attributes[:autofit],
      :hidden => ocolumn.attributes[:hidden]
    })
  end

  def rows(orows)
    orows.collect{|orow| row(orow)}
  end
  def row(orow)
    ::Xmlss::Row.new({
      :style_id => style_id(orow.attributes[:style_class]),
      :height => orow.attributes[:height],
      :auto_fit_height => orow.attributes[:autofit],
      :hidden => orow.attributes[:hidden],
      :cells => cells(orow.cells)
    })
  end

  def cells(ocells)
    ocells.collect{|ocell| cell(ocell)}
  end
  def cell(ocell)
    ::Xmlss::Cell.new({
      :style_id => style_id(ocell.attributes[:style_class], ocell.attributes[:format]),
      :href => ocell.attributes[:href],
      :index => ocell.attributes[:index],
      :merge_across => cell_merge(ocell.attributes[:colspan]),
      :merge_down => cell_merge(ocell.attributes[:rowspan]),
      :data => data(ocell.attributes[:data])
    })
  end
  def cell_merge(span)
    span.kind_of?(::Fixnum) && span > 1 ? span-1 : 0
  end
  def data(ocell_data)
    ::Xmlss::Data.new(ocell_data)
  end

end
