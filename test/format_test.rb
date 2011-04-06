require "test/helper"
require 'osheet/format'

module Osheet

  class FormatTest < Test::Unit::TestCase
    context "Osheet::Format" do
      subject do
        Format.new(:number, {
          :decimal_places => 4,
          :comma_separator => true,
          :negative_numbers => :black_parenth
        })
      end

      should "build format class instances" do
        assert_kind_of Format::Number, subject
        assert_equal 4, subject.decimal_places
        assert_equal true, subject.comma_separator
        assert_equal :black_parenth, subject.negative_numbers
      end

      should "error for invalid format types" do
        assert_raises ArgumentError do
          Format.new(:awesome, {})
        end
        assert_nothing_raised do
          Format.new(:general)
        end
      end

    end
  end

end
