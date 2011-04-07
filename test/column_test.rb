require "test/helper"
require "osheet/column"

module Osheet
  class ColumnTest < Test::Unit::TestCase

    context "Osheet::Column" do
      subject { Column.new }

      should_be_a_styled_element(Column)
      should_be_a_worksheet_element(Column)
      should_be_a_workbook_element(Column)

      should_have_instance_method :width
      should_have_instance_methods :autofit, :autofit?
      should_have_instance_methods :hidden, :hidden?
      should_have_instance_method :meta

      should "set it's defaults" do
        assert_equal nil, subject.send(:instance_variable_get, "@width")
        assert_equal false, subject.send(:instance_variable_get, "@autofit")
        assert !subject.autofit?
        assert_equal false, subject.send(:instance_variable_get, "@hidden")
        assert !subject.hidden?

        assert_equal nil, subject.meta
      end

      context "that has attributes" do
        subject do
          Column.new do
            style_class "more poo"
            width  100
            autofit true
            hidden true
            meta(
              {}
            )
          end
        end

        should "should set them correctly" do
          assert_equal 100, subject.send(:instance_variable_get, "@width")
          assert_equal true, subject.send(:instance_variable_get, "@autofit")
          assert subject.autofit?
          assert_equal true, subject.send(:instance_variable_get, "@hidden")
          assert subject.hidden?
          assert_equal({}, subject.meta)
        end

        should "know it's width" do
          subject.width(false)
          assert_equal false, subject.width
          subject.width(180)
          assert_equal 180, subject.width
          subject.width(nil)
          assert_equal 180, subject.width
        end

        should "know it's attribute(s)" do
          [:style_class, :width, :autofit, :hidden].each do |a|
            assert subject.attributes.has_key?(a)
          end
          assert_equal 'more poo', subject.attributes[:style_class]
          assert_equal 100, subject.attributes[:width]
          assert_equal true, subject.attributes[:autofit]
          assert_equal true, subject.attributes[:hidden]
        end

      end

      should "cast autofit and hidden to bool" do
        col = Column.new { autofit :true; hidden 'false'}
        assert_kind_of ::TrueClass, col.send(:instance_variable_get, "@autofit")
        assert_kind_of ::TrueClass, col.send(:instance_variable_get, "@hidden")
      end

    end

  end
end
