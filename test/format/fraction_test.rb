require "assert"
require 'osheet/format/fraction'

module Osheet::Format

  class FractionTest < Assert::Context
    desc "Fraction format"
    before { @f = Fraction.new }
    subject { @f }

    should have_accessors :type

    should "provide options for type" do
      assert_equal 9, Fraction.type_set.size
      [ :one_digit, :two_digits, :three_digits,
        :halves, :quarters, :eighths, :sixteenths,
        :tenths, :hundredths
      ].each do |a|
        assert Fraction.type_set.include?(a)
      end
    end

    should "set default values" do
      assert_equal '??/??', subject.type
      assert_equal :two_digits, subject.type_key
    end

    should "generate a one_digit type style strings and key" do
      f = Fraction.new(:type => :one_digit)
      assert_equal "#\ ?/?", f.style
      assert_equal "fraction_onedigit", f.key
    end

    should "generate a two_digit type style strings and key" do
      f = Fraction.new(:type => :two_digits)
      assert_equal "#\ ??/??", f.style
      assert_equal "fraction_twodigits", f.key
    end

    should "generate a three_digit type style strings and key" do
      f = Fraction.new(:type => :three_digits)
      assert_equal "#\ ???/???", f.style
      assert_equal "fraction_threedigits", f.key
    end

    should "generate a halves type style strings and key" do
      f = Fraction.new(:type => :halves)
      assert_equal "#\ ?/2", f.style
      assert_equal "fraction_halves", f.key
    end

    should "generate a quarters type style strings and key" do
      f = Fraction.new(:type => :quarters)
      assert_equal "#\ ?/4", f.style
      assert_equal "fraction_quarters", f.key
    end

    should "generate a eighths type style strings and key" do
      f = Fraction.new(:type => :eighths)
      assert_equal "#\ ?/8", f.style
      assert_equal "fraction_eighths", f.key
    end

    should "generate a sixteenths type style strings and key" do
      f = Fraction.new(:type => :sixteenths)
      assert_equal "#\ ??/16", f.style
      assert_equal "fraction_sixteenths", f.key
    end

    should "generate a tenths type style strings and key" do
      f = Fraction.new(:type => :tenths)
      assert_equal "#\ ?/10", f.style
      assert_equal "fraction_tenths", f.key
    end

    should "generate a hundredths type style strings and key" do
      f = Fraction.new(:type => :hundredths)
      assert_equal "#\ ??/100", f.style
      assert_equal "fraction_hundredths", f.key
    end

  end

end
