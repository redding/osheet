module Osheet::XmlssWriter::Elements

  protected

  def worksheet(xworkbook, oworksheet)
    xworkbook.worksheet(oworksheet.attributes[:name]) do
      oworksheet.columns.each { |ocolumn| column(xworkbook, ocolumn) }
      oworksheet.rows.each { |orow| row(xworkbook, orow) }
    end
  end

  def column(xworkbook, ocolumn)
    xworkbook.column({
      :style_id => style_id(xworkbook, ocolumn.attributes[:style_class]),
      :width => ocolumn.attributes[:width],
      :auto_fit_width => ocolumn.attributes[:autofit],
      :hidden => ocolumn.attributes[:hidden]
    })
  end

  def row(xworkbook, orow)
    xworkbook.row({
      :style_id => style_id(xworkbook, orow.attributes[:style_class]),
      :height => orow.attributes[:height],
      :auto_fit_height => orow.attributes[:autofit],
      :hidden => orow.attributes[:hidden]
    }) do
      orow.cells.each { |ocell| cell(xworkbook, ocell) }
    end
  end

  def cell(xworkbook, ocell)
    xworkbook.cell({
      :style_id => style_id(xworkbook, ocell.attributes[:style_class], ocell.attributes[:format]),
      :href => ocell.attributes[:href],
      :index => ocell.attributes[:index],
      :merge_across => cell_merge(ocell.attributes[:colspan]),
      :merge_down => cell_merge(ocell.attributes[:rowspan]),
      :formula => ocell.attributes[:formula]
    }) do
      data(xworkbook, ocell.attributes[:data])
    end
  end

  def data(xworkbook, odata)
    xworkbook.data(odata)
  end

  private

  # convert osheet col/row span value to xmlss merge value
  def cell_merge(span)
    span.kind_of?(::Fixnum) && span > 1 ? span-1 : 0
  end

end
