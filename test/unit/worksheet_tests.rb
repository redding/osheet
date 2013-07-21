require "assert"
require 'osheet/worksheet'

require 'osheet/column'
require 'osheet/row'

class Osheet::Worksheet

  class UnitTests < Assert::Context
    desc "Osheet::Worksheet"
    before { @wksht = Osheet::Worksheet.new }
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

  class WorksheetColumnTests < UnitTests
    desc "with columns"
    before {
      @col = Osheet::Column.new
      @wksht.column(@col)
    }

    should "know its cols" do
      assert_equal 1, subject.columns.size
      assert_same @col, subject.columns.first
    end

  end

  class WorksheetRowTests < UnitTests
    desc "with rows"
    before {
      @row = Osheet::Row.new
      @wksht.row(@row)
    }

    should "know its rows" do
      assert_equal 1, subject.rows.size
      assert_same @row, subject.rows.first
    end

    should "only keep the latest row" do
      new_row = Osheet::Row.new(120)
      subject.row(new_row)

      assert_equal 1, subject.rows.size
      assert_same new_row, subject.rows.last
    end

  end

  class WorksheetNameTests < UnitTests
    desc "with a name"
    before do
      @wksht = Osheet::Worksheet.new("fun")
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
      assert_equal "more fun", Osheet::Worksheet.new("more fun").name
    end

  end

end
