require "test/helper"
require 'osheet/worksheet'

module Osheet

  class WorksheetTest < Test::Unit::TestCase
    context "Osheet::Worksheet" do
      subject { Worksheet.new }

      should_be_a_workbook_element(Worksheet)

      should_have_instance_methods :name, :attributes
      should_have_instance_method :meta

      should "set it's defaults" do
        assert_equal nil, subject.send(:get_ivar, "name")
        assert_equal [], subject.columns
        assert_equal [], subject.rows

        assert_equal nil, subject.meta
      end

      should_hm(Worksheet, :columns, Column)
      should_hm(Worksheet, :rows, Row)

      should "know it's attribute(s)" do
        subject.send(:name, "Poo!")
        [:name].each do |a|
          assert subject.attributes.has_key?(a)
        end
        assert_equal "Poo!", subject.attributes[:name]
      end

    end
  end

  class WorksheetNameMetaTest < Test::Unit::TestCase
    context "A named worksheet with meta" do
      subject do
        Worksheet.new {
          name "Poo!"
          meta({})
        }
      end

      should "know it's name and meta" do
        assert_equal "Poo!", subject.send(:get_ivar, "name")
        assert_equal({}, subject.meta)
      end

      should "set it's name" do
        subject.name(false)
        assert_equal 'false', subject.name
        subject.name('la')
        assert_equal 'la', subject.name
        subject.name(nil)
        assert_equal 'la', subject.name
      end

      should "complain if name is longer than 31 chars" do
        assert_raises ArgumentError do
          subject.name('a'*32)
        end
        assert_nothing_raised do
          subject.name('a'*31)
        end
      end

    end
  end

  class WorksheetColumnRowTest < Test::Unit::TestCase
    context "A worksheet that has columns and rows" do
      subject do
        Worksheet.new {
          column
          row { cell {
            format  :number
            data    1
          } }
        }
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

  class WorkbookPartialTest < Test::Unit::TestCase
    context "A workbook that defines worksheet partials" do
      subject do
        Workbook.new {
          partial(:worksheet_stuff) {
            row {}
            row {}
          }

          worksheet {
            add :worksheet_stuff
          }
        }
      end

      should "add it's partials to it's markup" do
        assert_equal 2, subject.worksheets.first.rows.size
      end

    end
  end

  class WorksheetBindingTest < Test::Unit::TestCase
    context "a worksheet defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 'test'
        @worksheet = Worksheet.new { name @test }

        assert !@worksheet.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @worksheet.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @worksheet.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @worksheet.attributes[:name]
        assert_equal @test.object_id, @worksheet.attributes[:name].object_id
      end

    end
  end

end
