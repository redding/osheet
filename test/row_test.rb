require "assert"

require 'osheet/cell'
require 'osheet/row'

module Osheet

  class RowTests < Assert::Context
    desc "a Row"
    before { @rw = Row.new }
    subject { @rw }

    should be_a_styled_element
    should be_a_meta_element

    should have_reader :format
    should have_instance_methods :height
    should have_instance_methods :autofit, :autofit?
    should have_instance_methods :hidden, :hidden?
    should have_instance_methods :cells, :cell

    should "set it's defaults" do
      assert_equal nil, subject.height
      assert_equal false, subject.autofit
      assert !subject.autofit?
      assert_equal false, subject.hidden
      assert !subject.hidden?
      assert_kind_of Format::General, subject.format
    end

    should "set it's width" do
      subject.height(false)
      assert_equal false, subject.height

      subject.height(180)
      assert_equal 180, subject.height

      subject.height(nil)
      assert_equal 180, subject.height

      assert_equal 200, Row.new(200).height
    end

    should "cast autofit and hidden to bool" do
      row = Row.new
      row.autofit :true
      row.hidden 'false'

      assert_equal true, row.autofit
      assert_equal true, row.hidden
    end

  end

  class RowCellTests < RowTests
    desc "with cells"
    before {
      @cell = Cell.new
      @rw.cell(@cell)
    }

    should "know its cells" do
      assert_equal 1, subject.cells.size
      assert_same @cell, subject.cells.first
    end

  end



end
