class TestWriter

  attr_accessor :styles

  def initialize
    @styles = []
  end

  def style(obj)
    @styles << obj
  end

end
