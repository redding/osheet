require "test/helper"
require 'osheet/worksheet'

module Osheet
  class WorksheetTest < Test::Unit::TestCase

    context "Osheet::Worksheet" do
      subject { Worksheet.new }

      should_have_instance_methods :name, :column, :row

      should "set it's defaults" do
        assert_equal nil, subject.send(:instance_variable_get, "@name")
        assert_equal [], subject.send(:instance_variable_get, "@columns")
        assert_equal [], subject.send(:instance_variable_get, "@rows")
      end

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
          columns = subject.send(:instance_variable_get, "@columns")
          assert_equal 1, columns.size
          assert_kind_of Column, columns.first
        end

        should "set it's rows" do
          rows = subject.send(:instance_variable_get, "@rows")
          assert_equal 1, rows.size
          assert_kind_of Row, rows.first
        end
      end

    end

  end
end
