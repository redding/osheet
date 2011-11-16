require "assert"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::ElementsTest < Assert::Context
    before do
      @writer = XmlssWriter::Base.new
    end
    subject { @writer }

  end

  class XmlssWriter::WorksheetTest < XmlssWriter::ElementsTest
    desc "when writing a worksheet"
    before do
      @worksheet = Worksheet.new {
        name "testsheet2"
        column { width 100 }
        row { height 50 }
      }
    end

    should "create an Xmlss worksheet" do
      xmlss_worksheet = subject.send(:worksheet, @worksheet)
      assert_kind_of ::Xmlss::Worksheet, xmlss_worksheet
      assert_equal @worksheet.attributes[:name], xmlss_worksheet.name
      assert_kind_of ::Xmlss::Table, xmlss_worksheet.table
      assert_equal @worksheet.columns.size, xmlss_worksheet.table.columns.size
      assert_equal @worksheet.rows.size, xmlss_worksheet.table.rows.size
    end

    should "filter invalid worksheet names" do
      { 'valid name' => 'valid name',
        'valid 2' => 'valid 2',
        'invalid :' => 'invalid ',
        'invalid ;' => 'invalid ',
        'invalid *' => 'invalid ',
        'invalid /' => 'invalid ',
        'invalid \\' => 'invalid ',
        '[invalid]' => "invalid]"
      }.each do |k,v|
        assert_equal v, subject.send(:worksheet, Worksheet.new { name k}).name
      end
    end

  end

  class XmlssWriter::ColumnTest < XmlssWriter::ElementsTest
    desc "when writing a column"
    before do
      @column = Osheet::Column.new {
        style_class "awesome"
        width  100
        autofit true
        hidden true
        meta({
         :color => 'blue'
        })
      }
      @xmlss_column = subject.send(:column, @column)
    end

    should "create an Xmlss column" do
      assert_kind_of ::Xmlss::Column, @xmlss_column
      assert_equal @column.attributes[:width], @xmlss_column.width
      assert_equal @column.attributes[:autofit], @xmlss_column.auto_fit_width
      assert_equal @column.attributes[:hidden], @xmlss_column.hidden
    end

    should "style an Xmlss column" do
      assert_equal ".awesome", @xmlss_column.style_id
      assert_equal 1, subject.styles.size
      assert_kind_of ::Xmlss::Style::Base, subject.styles.first
      assert_equal @xmlss_column.style_id, subject.styles.first.id
    end
  end

  class XmlssWriter::RowTest < XmlssWriter::ElementsTest
    desc "when writing a row"
    before do
      @row = Osheet::Row.new do
        style_class "awesome thing"
        height  100
        autofit true
        hidden true
        cell {
          data  'one hundred'
        }
      end
      subject.workbook = Workbook.new {
        style('.awesome') {
          font 14
        }
        style('.thing') {
          font :italic
        }
        style('.awesome.thing') {
          font :bold
        }
      }
      @xmlss_row = subject.send(:row, @row)
    end

    should "create an Xmlss row" do
      assert_kind_of ::Xmlss::Row, @xmlss_row
      assert_equal @row.attributes[:height], @xmlss_row.height
      assert_equal @row.attributes[:autofit], @xmlss_row.auto_fit_height
      assert_equal @row.attributes[:hidden], @xmlss_row.hidden
      assert_equal 1, @xmlss_row.cells.size
    end

    should "style an Xmlss row" do
      assert_equal ".awesome.thing", @xmlss_row.style_id
      assert_equal 1, subject.styles.size
      assert_kind_of ::Xmlss::Style::Base, subject.styles.first
      assert_equal @xmlss_row.style_id, subject.styles.first.id
      assert_equal 14, subject.styles.first.font.size
      assert_equal true, subject.styles.first.font.bold?
      assert_equal true, subject.styles.first.font.italic?
    end
  end

  class XmlssWriter::CellTest < XmlssWriter::ElementsTest
    desc "when writing a cell"
    before do
      @cell = Osheet::Cell.new do
        style_class "awesome thing"
        data    100
        format  :number
        href    'http://example.com'
        rowspan 2
        colspan 5
        index 3
        formula "=R1C1"
      end
      subject.workbook = Workbook.new {
        style('.awesome') {
          font 14
        }
        style('.thing') {
          font :italic
        }
        style('.awesome.thing') {
          font :bold
        }
      }
      @xmlss_cell = subject.send(:cell, @cell)
    end

    should "create an Xmlss cell with appropriate data" do
      assert_kind_of ::Xmlss::Cell, @xmlss_cell
      assert_kind_of ::Xmlss::Data, @xmlss_cell.data
      assert_equal @cell.attributes[:data], @xmlss_cell.data.value
      assert_equal ::Xmlss::Data.type(:number), @xmlss_cell.data.type
      assert_equal 'http://example.com', @xmlss_cell.href
      assert_equal 3, @xmlss_cell.index
      assert_equal "=R1C1", @xmlss_cell.formula
    end

    should "handle rowspan and colspan" do
      assert_equal 1, @xmlss_cell.merge_down
      assert_equal 4, @xmlss_cell.merge_across
    end

    should "style an Xmlss cell" do
      assert_equal ".awesome.thing..number_none_0_nocomma_black", @xmlss_cell.style_id
      assert_equal ".awesome.thing..number_none_0_nocomma_black", subject.styles.first.id
      assert_equal '0', subject.styles.first.number_format.format
    end
  end

end
