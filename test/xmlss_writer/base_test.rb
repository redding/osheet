require "test/helper"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::BaseTest < Test::Unit::TestCase
    context "XmlssWriter::Base" do
      subject { XmlssWriter::Base.new }

      should_have_readers :workbook, :styles
      should_have_writer :workbook

    end
  end

  class XmlssWriter::Workbook < Test::Unit::TestCase
    context "XmlssWriter workbook" do
      subject { XmlssWriter::Base.new }
      before do
        @workbook = Workbook.new {
          title "xmlss"
          worksheet { name "testsheet1" }
        }
      end

      should "allow writing an Osheet::Workbook" do
        assert_nothing_raised do
          subject.workbook = @workbook
        end
        assert_raises ArgumentError do
          subject.workbook = "poo"
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
  end

end
