require "test/helper"
require 'osheet/dsl/workbook'

class Osheet::Dsl::WorkbookTest < Test::Unit::TestCase

  context "Osheet::Dsl::Workbook" do
    subject { Osheet::Dsl::Workbook.new }

    should_have_instance_methods :title, :worksheet

    should "set it's defaults" do
      assert_equal nil, subject.send(:instance_variable_get, "@title")
      assert_equal [], subject.send(:instance_variable_get, "@worksheets")
    end

    context "that has some columns and rows" do
      subject do
        Osheet::Dsl::Workbook.new do
          title "The Poo"

          worksheet do
            name "Poo!"

            column

            row do
              cell do
                format  :numeric
                data    1
              end
            end
          end
        end
      end

      should "set it's title" do
        assert_equal "The Poo", subject.send(:instance_variable_get, "@title")
      end

      should "set it's worksheets" do
        worksheets = subject.send(:instance_variable_get, "@worksheets")
        assert_equal 1, worksheets.size
        assert_kind_of Osheet::Dsl::Worksheet, worksheets.first
      end
    end

  end

end
