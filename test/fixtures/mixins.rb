require 'osheet/mixin'

class DefaultMixin
  include Osheet::Mixin

end

class StyledMixin
  include Osheet::Mixin

  style('.test')
  style('.test.awesome') {
    align :left
  }

end

class TemplatedMixin
  include Osheet::Mixin

  template(:column, :yo) { |color|
    width 200
    meta(:color => color)
  }
  template(:row, :yo_yo) {
    height 500
  }
  template(:worksheet, :go) {
    column(:yo, 'blue')
    row(:yo_yo)
  }

end

class PartialedMixin
  include Osheet::Mixin

  partial(:three_empty_rows) {
    row { }
    row { }
    row { }
  }

  partial(:two_cells_in_a_row) { |data_one, data_two|
    row {
      cell { data data_one.to_s }
      cell { data data_two.to_s }
    }
  }
end
