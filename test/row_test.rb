require "assert"
require 'osheet/row'

module Osheet

  class RowTest < Assert::Context
    desc "Osheet::Row"
    before { @rw = Row.new }
    subject { @rw }

    should_be_a_styled_element(Row)
    should_be_a_worksheet_element(Row)
    should_be_a_workbook_element(Row)

    should have_instance_method :height
    should have_instance_methods :autofit, :autofit?
    should have_instance_methods :hidden, :hidden?
    should have_instance_method :meta

    should_hm(Row, :cells, Cell)

    should "set it's defaults" do
      assert_equal nil, subject.send(:get_ivar, "height")
      assert_equal false, subject.send(:get_ivar, "autofit")
      assert !subject.autofit?
      assert_equal false, subject.send(:get_ivar, "hidden")
      assert !subject.hidden?

      assert_equal [], subject.cells
      assert_equal nil, subject.meta
    end

    should "set it's height" do
      subject.height(false)
      assert_equal false, subject.height
      subject.height(180)
      assert_equal 180, subject.height
      subject.height(nil)
      assert_equal 180, subject.height
    end

    should "cast autofit and hidden to bool" do
      rw = Row.new { autofit :true; hidden 'false'}
      assert_kind_of ::TrueClass, rw.send(:get_ivar, "autofit")
      assert_kind_of ::TrueClass, rw.send(:get_ivar, "hidden")
    end

  end

  class RowAttributeTest < RowTest
    desc "a row that has attributes"
    before do
      @rw = Row.new do
        style_class "poo"
        height  100
        autofit true
        hidden true
        meta(
          {}
        )
      end
    end

    should "should set them correctly" do
      assert_equal 100, subject.send(:get_ivar, "height")
      assert_equal true, subject.send(:get_ivar, "autofit")
      assert subject.autofit?
      assert_equal true, subject.send(:get_ivar, "hidden")
      assert subject.hidden?
      assert_equal({}, subject.meta)
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

  class RowPartialTest < Assert::Context
    desc "A workbook that defines column partials"
    before do
      @wkbk = Workbook.new {
        partial(:row_stuff) {
          height 200
          meta 'awesome'
        }

        worksheet { row {
          add :row_stuff
        } }
      }
    end
    subject { @wkbk }

    should "add it's partials to it's markup" do
      assert_equal 200, subject.worksheets.first.rows.first.height
      assert_equal 'awesome', subject.worksheets.first.rows.first.meta
    end

  end

  class RowBindingTest < Assert::Context
    desc "a row defined w/ a block"

    should "access instance vars from that block's binding" do
      @test = 50
      @row = Row.new { height @test }

      assert !@row.send(:instance_variable_get, "@test").nil?
      assert_equal @test, @row.send(:instance_variable_get, "@test")
      assert_equal @test.object_id, @row.send(:instance_variable_get, "@test").object_id
      assert_equal @test, @row.attributes[:height]
      assert_equal @test.object_id, @row.attributes[:height].object_id
    end

  end

end
