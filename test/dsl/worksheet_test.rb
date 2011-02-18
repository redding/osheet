require "test/helper"
require 'osheet/dsl/worksheet'

class Osheet::Dsl::WorksheetTest < Test::Unit::TestCase

  context "Osheet::Dsl::Worksheet" do
    subject { Osheet::Dsl::Worksheet.new }

    should_have_instance_methods :name, :column, :row

    should "set it's defaults" do
      assert_equal nil, subject.name_value
      assert_equal [], subject.columns_set
      assert_equal [], subject.rows_set
    end

    context "that has some columns and rows" do
      subject do
        Osheet::Dsl::Worksheet.new do
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

      should "set it's name" do
        assert_equal "Poo!", subject.send(:instance_variable_get, "@name")
      end

      should "set it's columns" do
        columns = subject.send(:instance_variable_get, "@columns")
        assert_eqaul 1, columns.size
        assert_kind_of Osheet::Dsl::Column, columns.first
      end

      should "set it's rows" do
        rows = subject.send(:instance_variable_get, "@rows")
        assert_eqaul 1, rows.size
        assert_kind_of Osheet::Dsl::Row, rows.first
      end
    end

  end

end
