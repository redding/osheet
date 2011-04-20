require "test/helper"
require 'osheet/cell'

module Osheet

  class CellTest < Test::Unit::TestCase
    context "Osheet::Cell" do
      subject { Cell.new }

      should_be_a_styled_element(Cell)
      should_be_a_worksheet_element(Cell)
      should_be_a_workbook_element(Cell)

      should_have_instance_methods :data, :format, :colspan, :rowspan, :href

      should "set it's defaults" do
        assert_equal nil, subject.send(:get_ivar, "data")
        assert_kind_of Format::General, subject.send(:get_ivar, "format")
        assert_equal 1,   subject.send(:get_ivar, "colspan")
        assert_equal 1,   subject.send(:get_ivar, "rowspan")
        assert_equal nil,   subject.send(:get_ivar, "href")
      end

    end
  end

  class CellAttributeTest < Test::Unit::TestCase
    context "a celll that has attributes" do
      subject do
        Cell.new do
          style_class 'more poo'
          data    "Poo"
          format  :number
          colspan 4
          rowspan 2
          href "http://www.google.com"
        end
      end

      should "should set them correctly" do
        assert_equal "Poo", subject.send(:get_ivar, "data")
        assert_kind_of Format::Number, subject.send(:get_ivar, "format")
        assert_equal 4,     subject.send(:get_ivar, "colspan")
        assert_equal 2,     subject.send(:get_ivar, "rowspan")
        assert_equal "http://www.google.com", subject.send(:get_ivar, "href")
      end

      should "know it's attribute(s)" do
        [:style_class, :data, :format, :rowspan, :colspan, :href].each do |a|
          assert subject.attributes.has_key?(a)
        end
        assert_equal "more poo", subject.attributes[:style_class]
        assert_equal "Poo", subject.attributes[:data]
        assert_kind_of Format::Number, subject.attributes[:format]
        assert_equal 4, subject.attributes[:colspan]
        assert_equal 2, subject.attributes[:rowspan]
        assert_equal "http://www.google.com", subject.attributes[:href]
      end

    end
  end

  class CellDataTest < Test::Unit::TestCase
    context "A cell" do
      subject { Cell.new }

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
  end

  class CellPartialTest < Test::Unit::TestCase
    context "A workbook that defines column partials" do
      subject do
        Workbook.new {
          partial(:cell_stuff) {
            style_class 'more poo'
            data "Poo"
          }

          worksheet { row { cell {
            add :cell_stuff
          } } }
        }
      end

      should "add it's partials to it's markup" do
        assert_equal 'more poo', subject.worksheets.first.rows.first.cells.first.attributes[:style_class]
        assert_equal 'Poo', subject.worksheets.first.rows.first.cells.first.attributes[:data]
      end

    end
  end

  class CellBindingTest < Test::Unit::TestCase
    context "a cell defined w/ a block" do
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

end
