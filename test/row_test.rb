require "test/helper"
require 'osheet/row'

module Osheet
  class RowTest < Test::Unit::TestCase

    context "Osheet::Row" do
      subject { Row.new }

      should_be_a_styled_element(Row)
      should_be_a_worksheet_element(Row)
      should_be_a_workbook_element(Row)

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
            style_class "poo"
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

        should "know it's attribute(s)" do
          [:style_class, :height, :autofit, :hidden].each do |a|
            assert subject.attributes.has_key?(a)
          end
          assert_equal 'poo', subject.attributes[:style_class]
          assert_equal 100, subject.attributes[:height]
          assert_equal true, subject.attributes[:autofit]
          assert_equal true, subject.attributes[:hidden]
        end

      end

      should "cast autofit and hidden to bool" do
        rw = Row.new { autofit :true; hidden 'false'}
        assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@autofit")
        assert_kind_of ::TrueClass, rw.send(:instance_variable_get, "@hidden")
      end

      should_hm(Row, :cells, Cell)

    end

  end
end
