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

        should "create an Xmlss worksheet" do
          xmlss_worksheet = subject.send(:worksheet, @worksheet)
          assert_kind_of ::Xmlss::Worksheet, xmlss_worksheet
          assert_equal @worksheet.attributes[:name], xmlss_worksheet.name
          assert_kind_of ::Xmlss::Table, xmlss_worksheet.table
          assert_equal @worksheet.columns.size, xmlss_worksheet.table.columns.size
          assert_equal @worksheet.rows.size, xmlss_worksheet.table.rows.size
        end
      end


      context "when writing a column" do
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
          # style handling basic tests:
          #  just testing basic style_class setting and that an xmlss
          #  style is added to the writer's style collection
          assert_equal ".awesome..", @xmlss_column.style_id
          assert_equal 1, subject.styles.size
          assert_kind_of ::Xmlss::Style::Base, subject.styles.first
          assert_equal ".awesome..", subject.styles.first.id
        end
      end


    end
  end
end
