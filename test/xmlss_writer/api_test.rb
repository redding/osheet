require "assert"

require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::ApiTest < Assert::Context
    before do
      @writer = XmlssWriter.new
      @workbook = Workbook.new(@writer)
    end
    subject { @writer }

  end

  class XmlssWriter::CellTests < XmlssWriter::ApiTest
    desc "when writing a cell"
    before do
      @cell = Osheet::Cell.new(100)
      @cell.style_class "awesome thing"
      @cell.format  :number
      @cell.href    'http://example.com'
      @cell.rowspan 2
      @cell.colspan 5
      @cell.index   3
      @cell.formula "=R1C1"
      @xmlss_cell = subject.cell(@cell)
    end

    should "create an Xmlss::Cell with correct attributes" do
      assert_kind_of ::Xmlss::Element::Cell, @xmlss_cell
      assert_equal 100, @xmlss_cell.data
      assert_equal 'http://example.com', @xmlss_cell.href
      assert_equal 3, @xmlss_cell.index
      assert_equal "=R1C1", @xmlss_cell.formula
      assert_equal 1, @xmlss_cell.merge_down
      assert_equal 4, @xmlss_cell.merge_across
    end

    should "style the cell" do
      assert_equal ".awesome.thing..number_none_0_nocomma_black", @xmlss_cell.style_id
      assert_equal 1, subject.style_cache.size
    end

    should "write cell element markup" do
      assert_equal(
        "<Cell ss:Formula=\"=R1C1\" ss:HRef=\"http://example.com\" ss:Index=\"3\" ss:MergeAcross=\"4\" ss:MergeDown=\"1\" ss:StyleID=\".awesome.thing..number_none_0_nocomma_black\"><Data ss:Type=\"Number\">100</Data></Cell>",
        xmlss_element_markup(subject)
      )
    end

  end

  class XmlssWriter::RowTests < XmlssWriter::ApiTest
    desc "when writing a row"
    before do
      @row = Osheet::Row.new
      @row.style_class "awesome thing"
      @row.height  100
      @row.autofit true
      @row.hidden  true
      @xmlss_row = subject.row(@row)
    end

    should "create an Xmlss::Row with correct attributes" do
      assert_kind_of ::Xmlss::Element::Row, @xmlss_row
      assert_equal 100,  @xmlss_row.height
      assert_equal true, @xmlss_row.auto_fit_height
      assert_equal true, @xmlss_row.hidden
    end

    should "style the row" do
      assert_equal ".awesome.thing", @xmlss_row.style_id
      assert_equal 1, subject.style_cache.size
    end

    should "write row element markup" do
      assert_equal(
        "<Row ss:AutoFitHeight=\"1\" ss:Height=\"100\" ss:Hidden=\"1\" ss:StyleID=\".awesome.thing\" />",
        xmlss_element_markup(subject)
      )
    end

  end

  class XmlssWriter::ColumnTests < XmlssWriter::ApiTest
    desc "when writing a column"
    before do
      @column = Osheet::Column.new
      @column.style_class "awesome"
      @column.width   100
      @column.autofit true
      @column.hidden  true
      @xmlss_column = subject.column(@column)
    end

    should "create an Xmlss::Column with correct attributes" do
      assert_kind_of ::Xmlss::Element::Column, @xmlss_column
      assert_equal 100,  @xmlss_column.width
      assert_equal true, @xmlss_column.auto_fit_width
      assert_equal true, @xmlss_column.hidden
    end

    should "style an Xmlss column" do
      assert_equal ".awesome", @xmlss_column.style_id
      assert_equal 1, subject.style_cache.size
    end

    should "write column element markup" do
      assert_equal(
        "<Column ss:AutoFitWidth=\"1\" ss:Hidden=\"1\" ss:StyleID=\".awesome\" ss:Width=\"100\" />",
        xmlss_element_markup(subject)
      )
    end

  end

  class XmlssWriter::WorksheetTests < XmlssWriter::ApiTest
    desc "when writing a worksheet"
    before do
      @worksheet = Worksheet.new("testsheet2")
      @xmlss_worksheet = subject.worksheet(@worksheet)
    end

    should "create an Xmlss::Worksheet with correct attributes" do
      assert_kind_of ::Xmlss::Element::Worksheet, @xmlss_worksheet
      assert_equal "testsheet2", @xmlss_worksheet.name
    end

    should "write worksheet element markup" do
      assert_equal(
        "<Worksheet ss:Name=\"testsheet2\"><Table /></Worksheet>",
        xmlss_element_markup(subject)
      )
    end

  end

end
