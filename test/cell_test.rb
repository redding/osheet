require "assert"
require 'osheet/cell'

module Osheet

  class CellTest < Assert::Context
    desc "Osheet::Cell"
    before { @c = Cell.new }
    subject { @c }

    should_be_a_styled_element(Cell)
    should_be_a_worksheet_element(Cell)
    should_be_a_workbook_element(Cell)

    should have_instance_methods :data, :format, :colspan, :rowspan, :href, :index

    should "set it's defaults" do
      assert_equal nil, subject.send(:get_ivar, "data")
      assert_kind_of Format::General, subject.send(:get_ivar, "format")
      assert_equal 1,   subject.send(:get_ivar, "colspan")
      assert_equal 1,   subject.send(:get_ivar, "rowspan")
      assert_equal nil,   subject.send(:get_ivar, "href")
      assert_equal nil,   subject.send(:get_ivar, "index")
      assert_equal nil,   subject.send(:get_ivar, "formula")
    end

    should "type cast data strings/symbols" do
      ['a string', :symbol].each do |thing|
        cell = Cell.new{data thing}
        assert_kind_of ::String, cell.send(:get_ivar, "data")
      end
    end

    should "type cast data dates" do
      cell = Cell.new{data Date.today}
      assert_kind_of ::Date, cell.send(:get_ivar, "data")
    end

    should "type cast data numerics" do
      [1, 1.0].each do |thing|
        cell = Cell.new{data thing}
        assert_kind_of ::Numeric, cell.send(:get_ivar, "data")
      end
    end

    should "type cast all other data to string" do
      [Osheet, [:a, 'Aye'], {:a => 'Aye'}].each do |thing|
        cell = Cell.new{data thing}
        assert_kind_of ::String, cell.send(:get_ivar, "data")
      end
    end

  end

  class CellAttributeTest < CellTest
    desc "a celll that has attributes"
    before do
      @c = Cell.new do
        style_class 'more poo'
        data    "Poo"
        format  :number
        colspan 4
        rowspan 2
        index 3
        formula "=R1C1"
        href "http://www.google.com"
      end
    end

    should "should set them correctly" do
      assert_equal "Poo", subject.send(:get_ivar, "data")
      assert_kind_of Format::Number, subject.send(:get_ivar, "format")
      assert_equal 4,       subject.send(:get_ivar, "colspan")
      assert_equal 2,       subject.send(:get_ivar, "rowspan")
      assert_equal 3,       subject.send(:get_ivar, "index")
      assert_equal "=R1C1", subject.send(:get_ivar, "formula")
      assert_equal "http://www.google.com", subject.send(:get_ivar, "href")
    end

    should "know it's attribute(s)" do
      [:style_class, :data, :format, :rowspan, :colspan, :index, :href].each do |a|
        assert subject.attributes.has_key?(a)
      end

      assert_equal "more poo", subject.attributes[:style_class]
      assert_equal "Poo", subject.attributes[:data]
      assert_kind_of Format::Number, subject.attributes[:format]
      assert_equal 4, subject.attributes[:colspan]
      assert_equal 2, subject.attributes[:rowspan]
      assert_equal 3, subject.attributes[:index]
      assert_equal "=R1C1", subject.attributes[:formula]
      assert_equal "http://www.google.com", subject.attributes[:href]
    end

  end

  class CellPartialTest < Assert::Context
    desc "A workbook that defines column partials"
    before do
      @wkbk = Workbook.new {
        partial(:cell_stuff) {
          style_class 'more poo'
          data "Poo"
        }

        worksheet { row { cell {
          add :cell_stuff
        } } }
      }
    end
    subject { @wkbk }

    should "add it's partials to it's markup" do
      assert_equal 'more poo', subject.worksheets.first.rows.first.cells.first.attributes[:style_class]
      assert_equal 'Poo', subject.worksheets.first.rows.first.cells.first.attributes[:data]
    end

  end

  class CellBindingTest < Assert::Context
    desc "a cell defined w/ a block"

    should "access instance vars from that block's binding" do
      @test = 'test'
      @cell = Cell.new { data @test}

      assert !@cell.send(:instance_variable_get, "@test").nil?
      assert_equal @test, @cell.send(:instance_variable_get, "@test")
      assert_equal @test.object_id, @cell.send(:instance_variable_get, "@test").object_id
      assert_equal @test, @cell.attributes[:data]
      assert_equal @test.object_id, @cell.attributes[:data].object_id
    end
  end

end
