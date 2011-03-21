require "test/helper"
require 'osheet/row'

class Osheet::RowTest < Test::Unit::TestCase

  context "Osheet::Row" do
    subject { Osheet::Row.new }

    should_have_instance_method :height
    should_have_instance_methods :autofit, :autofit?
    should_have_instance_methods :hidden, :hidden?

    should_be_a_styled_element(Osheet::Row)

    should "set it's defaults" do
      assert_equal nil, subject.send(:instance_variable_get, "@height")
      assert_equal false, subject.send(:instance_variable_get, "@autofit")
      assert !subject.autofit?
      assert_equal false, subject.send(:instance_variable_get, "@hidden")
      assert !subject.hidden?

      assert_equal [], subject.cells
    end

    context "that has attributes" do
      subject do
        Osheet::Row.new do
          height  100
          autofit true
          hidden true
        end
      end

      should "should set them correctly" do
        assert_equal 100, subject.send(:instance_variable_get, "@height")
        assert_equal true, subject.send(:instance_variable_get, "@autofit")
        assert subject.autofit?
        assert_equal true, subject.send(:instance_variable_get, "@hidden")
        assert subject.hidden?
      end
    end

    should "cast autofit and hidden to bool" do
      rw = Osheet::Row.new { autofit :true; hidden 'false'}
      assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@autofit")
      assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@hidden")
    end



    should_have_reader :cells
    should_have_instance_method :cell

    context "that has some cells" do
      subject do
        Osheet::Row.new do
          cell do
            data "name"
          end
          cell do
            data    1
          end
        end
      end

      should "should initialize and add them to it's collection" do
        cells = subject.send(:instance_variable_get, "@cells")
        assert_equal cells, subject.cells
        assert !cells.empty?
        assert_equal 2, cells.size
        assert_kind_of Osheet::Cell, cells.first
        assert_equal "name", cells.first.send(:instance_variable_get, "@data")
        assert_kind_of Osheet::Cell, cells.last
        assert_equal 1, cells.last.send(:instance_variable_get, "@data")
      end
    end

  end

end
