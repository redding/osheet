require "assert"
require "osheet/column"

module Osheet

  class ColumnTest < Assert::Context
    desc "Osheet::Column"
    before { @c = Column.new }
    subject { @c }

    should_be_a_styled_element(Column)
    should_be_a_worksheet_element(Column)
    should_be_a_workbook_element(Column)

    should have_instance_method :width
    should have_instance_methods :autofit, :autofit?
    should have_instance_methods :hidden, :hidden?
    should have_instance_method :meta

    should "set it's defaults" do
      assert_equal nil, subject.send(:get_ivar, "width")
      assert_equal false, subject.send(:get_ivar, "autofit")
      assert !subject.autofit?
      assert_equal false, subject.send(:get_ivar, "hidden")
      assert !subject.hidden?

      assert_equal nil, subject.meta
    end

    should "set it's width" do
      subject.width(false)
      assert_equal false, subject.width
      subject.width(180)
      assert_equal 180, subject.width
      subject.width(nil)
      assert_equal 180, subject.width
    end

    should "cast autofit and hidden to bool" do
      col = Column.new { autofit :true; hidden 'false'}
      assert_kind_of ::TrueClass, col.send(:get_ivar, "autofit")
      assert_kind_of ::TrueClass, col.send(:get_ivar, "hidden")
    end

  end

  class ColumnAttributesTest < ColumnTest
    desc "that has attributes"
    before do
      @c = Column.new do
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
      assert_equal 100, subject.send(:get_ivar, "width")
      assert_equal true, subject.send(:get_ivar, "autofit")
      assert subject.autofit?
      assert_equal true, subject.send(:get_ivar, "hidden")
      assert subject.hidden?
      assert_equal({}, subject.meta)
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

  class ColumnPartialTest < Assert::Context
    desc "A workbook that defines column partials"
    before do
      @wkbk = Workbook.new {
        partial(:column_stuff) {
          width 200
          meta(:label => 'awesome')
        }

        worksheet { column {
          add :column_stuff
        } }
      }
    end
    subject { @wkbk }

    should "add it's partials to it's markup" do
      assert_equal 200, subject.worksheets.first.columns.first.width
      assert_equal({:label => 'awesome'}, subject.worksheets.first.columns.first.meta)
    end

  end

  class ColumnBindingTest < Assert::Context
    desc "a column defined w/ a block"

    should "access instance vars from that block's binding" do
      @test = 50
      @col = Column.new { width @test }

      assert !@col.send(:instance_variable_get, "@test").nil?
      assert_equal @test, @col.send(:instance_variable_get, "@test")
      assert_equal @test.object_id, @col.send(:instance_variable_get, "@test").object_id
      assert_equal @test, @col.attributes[:width]
      assert_equal @test.object_id, @col.attributes[:width].object_id
    end

  end

end
