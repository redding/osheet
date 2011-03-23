require "test/helper"
require 'osheet/row'

module Osheet
  class RowTest < Test::Unit::TestCase

    context "Osheet::Row" do
      subject { Row.new }

      should_be_a_styled_element(Row)
      should_be_a_worksheet_element(Row)

      should_have_instance_method :height
      should_have_instance_methods :autofit, :autofit?
      should_have_instance_methods :hidden, :hidden?

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
          Row.new do
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
        rw = Row.new { autofit :true; hidden 'false'}
        assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@autofit")
        assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@hidden")
      end

      should_hm(Row, :cells, Cell)
      # TODO: template cell creation against a fixture

    end

  end
end
