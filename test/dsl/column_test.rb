require "test/helper"
require "osheet/dsl/column"

class Osheet::Dsl::ColumnTest < Test::Unit::TestCase

  context "Osheet::Dsl::Column" do
    subject { Osheet::Dsl::Column.new }

    should "initialize" do
      assert subject
    end
  end

end
