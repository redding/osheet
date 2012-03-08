class TestWriter

  attr_accessor :styles, :worksheets, :columns, :rows, :cells

  def initialize
    @styles = []
    @worksheets = []
    @columns = []
    @rows = []
    @cells = []
  end

  def bind(workbook)
    workbook
  end

  def style(obj, &block)
    @styles << obj
    block.call if !block.nil?
  end

  def worksheet(obj, &block)
    @worksheets << obj
    block.call if !block.nil?
  end

  def column(obj, &block)
    @columns << obj
    block.call if !block.nil?
  end

  def row(obj, &block)
    @rows << obj
    block.call if !block.nil?
  end

  def cell(obj, &block)
    @cells << obj
    block.call if !block.nil?
  end

  def style(*args)
    return *args
  end

  [ :title,       # workbook_element
    :name,        # worksheet
    :meta,        # worksheet, column, row, cell
    :width,       # column
    :height,      # row
    :autofit,     # column, row
    :autofit?,    # column, row
    :hidden,      # column, row
    :hidden?,     # column, row
    :data,        # cell
    :href,        # cell
    :formula,     # cell
    :index,       # cell
    :rowspan,     # cell
    :colspan,     # cell
  ].each do |meth|
    define_method(meth) do |*args|
      # cool story bro (don't do anything, just allow)
      return *args
    end
  end

end
