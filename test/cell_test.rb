require "assert"
require 'osheet/cell'

module Osheet

  class CellTests < Assert::Context
    desc "a Cell"
    before { @c = Cell.new }
    subject { @c }

    should be_a_styled_element
    should be_a_meta_element

    should have_instance_methods :data, :format, :href, :index
    should have_instance_methods :colspan, :rowspan

    should "set it's defaults" do
      assert_equal nil, subject.data
      assert_kind_of Format::General, subject.format
      assert_equal 1,   subject.colspan
      assert_equal 1,   subject.rowspan
      assert_equal nil, subject.href
      assert_equal nil, subject.index
      assert_equal nil, subject.formula
    end

    should "set its data from an init arg" do
      assert_equal "something", Cell.new("something").data
    end

    should "type cast data strings/symbols" do
      ['a string', :symbol].each do |thing|
        subject.data thing
        assert_kind_of ::String, subject.data
      end
    end

    should "type cast data dates" do
      subject.data Date.today
      assert_kind_of ::Date, subject.data
    end

    should "type cast data numerics" do
      [1, 1.0].each do |thing|
        subject.data thing
        assert_kind_of ::Numeric, subject.data
      end
    end

    should "type cast all other data to string" do
      [Osheet, [:a, 'Aye'], {:a => 'Aye'}].each do |thing|
        subject.data thing
        assert_kind_of ::String, subject.data
      end
    end

    should "format data explicitly" do
      subject.data Time.now
      subject.format :datetime, 'mm/dd/yyyy'

      assert_kind_of Format::Datetime, subject.format
    end

  end

end
