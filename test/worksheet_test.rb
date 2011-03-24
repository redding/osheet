require "test/helper"
require 'osheet/worksheet'

module Osheet
  class WorksheetTest < Test::Unit::TestCase

    context "Osheet::Worksheet" do
      subject { Worksheet.new }

      should_be_a_workbook_element(Worksheet)

      should_have_instance_methods :name

      should "set it's defaults" do
        assert_equal nil, subject.send(:instance_variable_get, "@name")
        assert_equal [], subject.columns
        assert_equal [], subject.rows
      end

      should_hm(Worksheet, :columns, Column)
      should_hm(Worksheet, :rows, Row)

      context "that has some columns and rows" do
        subject do
          Worksheet.new do
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
          columns = subject.columns
          assert_equal 1, columns.size
          assert_kind_of Column, columns.first
          assert_equal subject.columns, columns.first.columns
        end

        should "set it's rows" do
          rows = subject.rows
          assert_equal 1, rows.size
          assert_kind_of Row, rows.first
          assert_equal subject.columns, rows.first.columns
          assert_equal subject.columns, rows.first.cells.first.columns
        end
      end

    end

  end
end
