require "test/helper"
require 'osheet/dsl/cell'

class Osheet::Dsl::CellTest < Test::Unit::TestCase

  context "Osheet::Dsl::Cell" do
    subject { Osheet::Dsl::Cell.new }

    should_have_instance_methods :data, :format, :colspan, :rowspan

    should "set it's defaults" do
      assert_equal nil, subject.data_value
      assert_equal nil, subject.format_value
      assert_equal 1,   subject.colspan_value
      assert_equal 1,   subject.rowspan_value
    end

    context "that has attributes" do
      subject do
        Osheet::Dsl::Cell.new do
          format  :text
          colspan 4
          rowspan 2
          data    "Poo"
        end
      end

      should "should set them correctly" do
        assert_equal "Poo", subject.data_value
        assert_equal :text, subject.format_value
        assert_equal 4,     subject.colspan_value
        assert_equal 2,     subject.rowspan_value
      end
    end

  end

end
