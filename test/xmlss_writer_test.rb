require "assert"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriterTest < Assert::Context
    desc "the xmlss writer"
    before do
      @writer = XmlssWriter.new
      @workbook = Workbook.new(@writer)
    end
    subject { @writer }

    should have_reader :style_cache, :xmlss_workbook
    should have_instance_methods :bind, :to_s, :to_data, :to_file

    should have_instance_methods :worksheet, :column, :row, :cell
    should have_instance_methods :style
    should have_instance_methods :name
    should have_instance_methods :width, :height
    should have_instance_methods :autofit, :autofit?, :hidden, :hidden?
    should have_instance_methods :data, :format, :href, :formula
    should have_instance_methods :index, :rowspan, :colspan

  end

  class XmlssWriterWorkbookTests < XmlssWriterTest
    before do
      @workbook.worksheet("testsheet1")
    end

    should "not allow multiple worksheets with the same name" do
      assert_raises ArgumentError do
        subject.worksheet(Worksheet.new("testsheet1"))
      end
      assert_nothing_raised do
        subject.worksheet(Worksheet.new("testsheet2"))
        subject.worksheet(Worksheet.new) {
          subject.name 'testsheet3'
        }
        subject.worksheet(Worksheet.new) {
          subject.name 'testsheet4'
        }
      end
    end

  end

  class XmlssWriterToFileTests < XmlssWriterTest
    desc "used with a workbook"
    before do
      Workbook.new(@writer) {
        title "written"
        worksheet {
          name "Test!"
          column
          row {
            cell {
              data 1
              format :number
            }
          }
        }
      }
    end

    should "write workbook markup" do
      assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"><Styles><Style ss:ID=\"..number_none_0_nocomma_black\"><NumberFormat ss:Format=\"0\" /></Style></Styles><Worksheet ss:Name=\"Test!\"><Table><Column /><Row><Cell ss:StyleID=\"..number_none_0_nocomma_black\"><Data ss:Type=\"Number\">1</Data></Cell></Row></Table></Worksheet></Workbook>", @writer.to_s
    end

    should "return string xml data" do
      xml_data = subject.to_s
      assert_kind_of ::String, xml_data
      assert_match /^<\?xml/, xml_data
      assert_equal xml_data, subject.to_data
    end

    should "write xml data to a file path" do
      path = subject.to_file("./tmp/base_test.xls")
      assert_kind_of ::String, path
      assert_equal './tmp/base_test.xls', path
      assert File.exists?(path)

      File.open(path) do |f|
        assert_equal subject.to_data, f.read
      end
    end

  end

end
