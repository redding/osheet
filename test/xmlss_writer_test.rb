require "test/helper"
require 'osheet/xmlss_writer'

module Osheet
  class XmlssWriterTest < Test::Unit::TestCase
    context "Osheet::XmlssWriter" do


      subject { XmlssWriter.new }

      should "be available" do
        assert subject
      end

      should_have_readers :workbook

      context "when writing a workbook" do
        before do
          @workbook = Osheet::Workbook.new {
            title "xmlss"
            worksheet { name "testsheet1" }
          }
        end

        should_have_writer :workbook

        should "allow writing an Osheet::Workbook" do
          assert_raises ArgumentError do
            subject.workbook = "poo"
          end
          assert_nothing_raised do
            subject.workbook = @workbook
          end
        end

        should "create an Xmlss workbook" do
          assert_nothing_raised do
            subject.workbook = @workbook
          end
          assert_kind_of ::Xmlss::Workbook, subject.workbook
          assert_equal @workbook.worksheets.size, subject.workbook.worksheets.size
        end
      end


      context "when writing a worksheet" do
        before do
          @worksheet = Osheet::Worksheet.new {
            name "testsheet2"
            column { width 100 }
            row { height 50 }
          }
        end

        should "create an Xmlss workbook" do
          xmlss_worksheet = subject.send(:worksheet, @worksheet)
          assert_kind_of ::Xmlss::Worksheet, xmlss_worksheet
          assert_equal "testsheet2", xmlss_worksheet.name
          assert_kind_of ::Xmlss::Table, xmlss_worksheet.table
          assert_equal @worksheet.columns.size, xmlss_worksheet.table.columns.size
          #assert_equal @worksheet.columns.first.attributes[:width], xmlss_worksheet.table.columns.first.width
          assert_equal @worksheet.rows.size, xmlss_worksheet.table.rows.size
          #assert_equal @worksheet.rows.first.attributes[:height], xmlss_worksheet.table.rows.first.height
        end
      end


    end
  end
end
