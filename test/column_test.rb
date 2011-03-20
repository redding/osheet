require "test/helper"
require "osheet/column"

class Osheet::ColumnTest < Test::Unit::TestCase

  context "Osheet::Column" do
    subject { Osheet::Column.new }

    should "initialize" do
      assert subject
    end
  end

end
