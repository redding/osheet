class TestWriter

  attr_accessor :styles, :worksheets, :columns, :rows, :cells

  def initialize
    @styles = []
    @worksheets = []
    @columns = []
    @rows = []
    @cells = []
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

end
