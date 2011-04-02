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

  class XmlssWriter::ToData < Test::Unit::TestCase
    context "XmlssWriter::Base" do
      subject do
        XmlssWriter::Base.new({
          :workbook => Workbook.new {
            title "written"
            worksheet {
              name "Poo!"
              column
              row {
                cell {
                  data 1
                  format "Currency"
                }
              }
            }
          }
        })
      end
      after do
        # remove any test files this creates
      end

      should_have_instance_methods :to_data, :to_file

      should "return string xml data" do
        xml_data = nil
        assert_nothing_raised do
          xml_data = subject.to_data
        end
        assert_kind_of ::String, xml_data
        assert_match /^<\?xml/, xml_data
      end

      should "write xml data to a file path" do
        path = nil
        assert_nothing_raised do
          path = subject.to_file("./tmp/base_test.xls")
        end
        assert_kind_of ::String, path
        assert_equal './tmp/base_test.xls', path
        assert File.exists?(path)
      end

    end
  end

end
