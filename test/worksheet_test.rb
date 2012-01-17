require "assert"

require 'osheet/column'
require 'osheet/row'
require 'osheet/worksheet'

module Osheet

  class WorksheetTests < Assert::Context
    desc "a Worksheet"
    before { @wksht = Worksheet.new }
    subject { @wksht }

    should be_a_meta_element

    should have_instance_methods :name
    should have_instance_methods :columns, :column
    should have_instance_methods :rows, :row

    should "set it's defaults" do
      assert_equal nil, subject.name
      assert_equal [],  subject.columns
      assert_equal [],  subject.rows
    end

  end

  class WorksheetColumnTests < WorksheetTests
    desc "with columns"
    before {
      @col = Column.new
      @wksht.column(@col)
    }

    should "know its cols" do
      assert_equal 1, subject.columns.size
      assert_same @col, subject.columns.first
    end

  end

  class WorksheetRowTests < WorksheetTests
    desc "with rows"
    before {
      @row = Row.new
      @wksht.row(@row)
    }

    should "know its rows" do
      assert_equal 1, subject.rows.size
      assert_same @row, subject.rows.first
    end

    should "only keep the latest row" do
      new_row = Row.new(120)
      subject.row(new_row)

      assert_equal 1, subject.rows.size
      assert_same new_row, subject.rows.last
    end

  end

  class WorksheetNameTests < WorksheetTests
    desc "with a name"
    before do
      @wksht = Worksheet.new("fun")
    end

    should "know it's name" do
      assert_equal "fun", subject.name
    end

    should "set it's name" do
      subject.name(false)
      assert_equal 'false', subject.name
      subject.name('la')
      assert_equal 'la', subject.name
      subject.name(nil)
      assert_equal 'la', subject.name
    end

    should "set it's name with an init parameter" do
      assert_equal "more fun", Worksheet.new("more fun").name
    end

    should "complain if given a name longer than 31 chars" do
      assert_raises ArgumentError do
        subject.name('a'*32)
      end
      assert_nothing_raised do
        subject.name('a'*31)
      end
    end

  end

end
