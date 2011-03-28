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
          assert_equal @workbook.worksheets.first.attributes[:name], subject.workbook.worksheets.first.name
        end
      end


    end
  end
end
