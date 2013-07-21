require "assert"
require 'osheet/format'

module Osheet::Format

  class UnitTests < Assert::Context
    desc "Osheet::Format"
    before do
      @f = Osheet::Format.new(:number, {
        :decimal_places => 4,
        :comma_separator => true,
        :negative_numbers => :black_parenth
      })
    end
    subject { @f }

    should "build format class instances" do
      assert_kind_of Osheet::Format::Number, subject
      assert_equal 4, subject.decimal_places
      assert_equal true, subject.comma_separator
      assert_equal 'black_parenth', subject.negative_numbers
    end

    should "error for invalid format types" do
      assert_raises ArgumentError do
        Osheet::Format.new(:awesome, {})
      end

      assert_nothing_raised do
        Osheet::Format.new(:general)
      end
    end

  end

end
