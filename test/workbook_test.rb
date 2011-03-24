require "test/helper"
require 'osheet/workbook'

module Osheet
  class WorkbookTest < Test::Unit::TestCase

    context "Osheet::Workbook" do
      subject { Workbook.new }

      should_have_readers :styles, :templates
      should_have_instance_methods :title, :style, :template

      should_hm(Workbook, :worksheets, Worksheet)

      should "set it's defaults" do
        assert_equal nil, subject.send(:instance_variable_get, "@title")
        assert_equal [], subject.worksheets
        assert_equal [], subject.styles
        assert_equal TemplateSet.new, subject.templates
      end

      context "that has some columns and rows" do
        subject do
          Workbook.new {
            title "The Poo"

            worksheet {
              name "Poo!"

              column

              row {
                cell {
                  format  :numeric
                  data    1
                }
              }
            }
          }
        end

        should "set it's title" do
          assert_equal "The Poo", subject.send(:instance_variable_get, "@title")
        end

        should "set it's worksheets" do
          worksheets = subject.send(:instance_variable_get, "@worksheets")
          assert_equal 1, worksheets.size
          assert_kind_of Worksheet, worksheets.first
        end
      end

      context "that defines styles" do
        subject do
          Workbook.new {
            style('.test')
            style('.test.awesome')
          }
        end

        should "add them to it's styles" do
          assert_equal 2, subject.styles.size
          assert_equal 1, subject.styles.first.selectors.size
          assert_equal '.test', subject.styles.first.selectors.first
          assert_equal 1, subject.styles.last.selectors.size
          assert_equal '.test.awesome', subject.styles.last.selectors.first
        end
      end

      context "that defines templates" do
        subject do
          Workbook.new {
            template(:column, :yo) {
              width 200
              meta(:color => 'blue')
            }
            template(:row, :yo_yo) {
              height 500
            }
          }
        end

        should "add them to it's templates" do
          assert subject.templates
          assert_kind_of TemplateSet, subject.templates
          assert_equal 2, subject.templates.keys.size
          assert_kind_of Template, subject.templates.for('column', 'yo').first
          assert_kind_of Template, subject.templates.for('row', 'yo_yo').first
        end
      end

    end

  end
end
