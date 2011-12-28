require "assert"

require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::ElementsTest < Assert::Context
    before do
      @writer = XmlssWriter::Base.new
      @xworkbook = ::Xmlss::Workbook.new
    end
    subject { @writer }

  end

  class XmlssWriter::CellTests < XmlssWriter::ElementsTest
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
      @xmlss_cell = subject.send(:cell, @xworkbook, @cell)
    end

    should "create an Xmlss cell with appropriate attributes" do
      assert_kind_of ::Xmlss::Element::Cell, @xmlss_cell
      assert_equal 'http://example.com', @xmlss_cell.href
      assert_equal 3, @xmlss_cell.index
      assert_equal "=R1C1", @xmlss_cell.formula
      assert_equal 1, @xmlss_cell.merge_down
      assert_equal 4, @xmlss_cell.merge_across
    end

    should "style an Xmlss cell" do
      assert_equal ".awesome.thing..number_none_0_nocomma_black", @xmlss_cell.style_id
      assert_equal 1, subject.used_xstyles.size
      assert_kind_of ::Xmlss::Style::Base, subject.used_xstyles.first
      assert_equal @xmlss_cell.style_id, subject.used_xstyles.first.id
    end

    should "write row element markup" do
      assert_equal(
        "<Cell ss:Formula=\"=R1C1\" ss:HRef=\"http://example.com\" ss:Index=\"3\" ss:MergeAcross=\"4\" ss:MergeDown=\"1\" ss:StyleID=\".awesome.thing..number_none_0_nocomma_black\"><Data ss:Type=\"Number\">100</Data></Cell>",
        xelement_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::RowTests < XmlssWriter::ElementsTest
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
      @xmlss_row = subject.send(:row, @xworkbook, @row)
    end

    should "create an Xmlss row" do
      assert_kind_of ::Xmlss::Element::Row, @xmlss_row
      assert_equal @row.attributes[:height], @xmlss_row.height
      assert_equal @row.attributes[:autofit], @xmlss_row.auto_fit_height
      assert_equal @row.attributes[:hidden], @xmlss_row.hidden
    end

    should "style an Xmlss row" do
      assert_equal ".awesome.thing", @xmlss_row.style_id
      assert_equal 1, subject.used_xstyles.size
      assert_kind_of ::Xmlss::Style::Base, subject.used_xstyles.first
      assert_equal @xmlss_row.style_id, subject.used_xstyles.first.id
    end

    should "write row element markup" do
      assert_equal(
        "<Row ss:AutoFitHeight=\"1\" ss:Height=\"100\" ss:Hidden=\"1\" ss:StyleID=\".awesome.thing\"><Cell><Data ss:Type=\"String\">one hundred</Data></Cell></Row>",
        xelement_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::ColumnTests < XmlssWriter::ElementsTest
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
      @xmlss_column = subject.send(:column, @xworkbook, @column)
    end

    should "create an Xmlss column" do
      assert_kind_of ::Xmlss::Element::Column, @xmlss_column
      assert_equal @column.attributes[:width], @xmlss_column.width
      assert_equal @column.attributes[:autofit], @xmlss_column.auto_fit_width
      assert_equal @column.attributes[:hidden], @xmlss_column.hidden
    end

    should "style an Xmlss column" do
      assert_equal ".awesome", @xmlss_column.style_id
      assert_equal 1, subject.used_xstyles.size
      assert_kind_of ::Xmlss::Style::Base, subject.used_xstyles.first
      assert_equal @xmlss_column.style_id, subject.used_xstyles.first.id
    end

    should "write column element markup" do
      assert_equal(
        "<Column ss:AutoFitWidth=\"1\" ss:Hidden=\"1\" ss:StyleID=\".awesome\" ss:Width=\"100\" />",
        xelement_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::WorksheetTests < XmlssWriter::ElementsTest
    desc "when writing a worksheet"
    before do
      @worksheet = Worksheet.new do
        name "testsheet2"
        column { width 100 }
        row { height 50 }
      end
    end

    should "create an Xmlss worksheet" do
      xmlss_worksheet = subject.send(:worksheet, @xworkbook, @worksheet)
      assert_kind_of ::Xmlss::Element::Worksheet, xmlss_worksheet
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
        assert_equal v, subject.send(:worksheet,  @xworkbook, Worksheet.new { name k }).name
      end
    end

    should "write worksheet element markup" do
      subject.send(:worksheet, @xworkbook, @worksheet)
      assert_equal(
        "<Worksheet ss:Name=\"testsheet2\"><Table><Column ss:Width=\"100\" /><Row ss:Height=\"50\"></Row></Table></Worksheet>",
        xelement_markup(@xworkbook)
      )
    end

  end

end
