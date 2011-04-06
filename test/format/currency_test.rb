require "test/helper"
require 'osheet/format/currency'

module Osheet::Format

  class CurrencyTest < Test::Unit::TestCase
    context "Currency format" do
      subject { Currency.new }

      should_have_accessors :decimal_places, :symbol, :comma_separator, :negative_numbers

      should "provide symbol options" do
        assert_equal 3, Currency.symbol_set.size
        [:none, :dollar, :euro].each do |a|
          assert Currency.symbol_set.include?(a)
        end
      end

      should "provide negative numbers options" do
        assert_equal 4, Currency.negative_numbers_set.size
        [:black, :black_parenth, :red, :red_parenth].each do |a|
          assert Currency.negative_numbers_set.include?(a)
        end
      end

      should "set default values" do
        assert_equal 2, subject.decimal_places
        assert_equal :dollar, subject.symbol
        assert_equal true, subject.comma_separator
        assert_equal :black, subject.negative_numbers
      end

      should "only allow Fixnum decimal places between 0 and 30" do
        assert_raises ArgumentError do
          Currency.new({:decimal_places => -1})
        end
        assert_raises ArgumentError do
          Currency.new({:decimal_places => 31})
        end
        assert_raises ArgumentError do
          Currency.new({:decimal_places => 'poo'})
        end
        assert_nothing_raised do
          Currency.new({:decimal_places => 1})
        end
      end

      should "generate decimal place style strings" do
        assert_equal "0", Currency.new({
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
        (1..5).each do |n|
          assert_equal "0.#{'0'*n}", Currency.new({
            :decimal_places => n,
            :comma_separator => false,
            :symbol => :none
          }).style
        end
      end

      should "generate comma separator style strings" do
        assert_equal "0", Currency.new({
          :comma_separator => false,
          :decimal_places => 0,
          :symbol => :none
        }).style
        assert_equal "#,##0", Currency.new({
          :comma_separator => true,
          :decimal_places => 0,
          :symbol => :none
        }).style
      end

      should "generate parenth negative numbers style strings" do
        assert_equal "0", Currency.new({
          :negative_numbers => :black,
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
        assert_equal "0_);\(0\)", Currency.new({
          :negative_numbers => :black_parenth,
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
      end

      should "generate red negative numbers style strings" do
        assert_equal "0;[Red]0", Currency.new({
          :negative_numbers => :red,
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
        assert_equal "0_);[Red]\(0\)", Currency.new({
          :negative_numbers => :red_parenth,
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
      end

      should "generate symbol style strings" do
        assert_equal "0", Currency.new({
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :none
        }).style
        assert_equal "\"$\"0", Currency.new({
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :dollar
        }).style
        assert_equal "[$€-2]\ 0", Currency.new({
          :decimal_places => 0,
          :comma_separator => false,
          :symbol => :euro
        }).style
      end

      should "generate complex style string" do
        assert_equal("\"$\"0.00_);\(\"$\"0.00\)", Currency.new({
          :symbol => :dollar,
          :decimal_places => 2,
          :negative_numbers => :black_parenth,
          :comma_separator => false
        }).style)
        assert_equal("[$€-2]\ #,##0.0000_);[Red]\([$€-2]\ #,##0.0000\)", Currency.new({
          :symbol => :euro,
          :decimal_places => 4,
          :negative_numbers => :red_parenth,
          :comma_separator => true
        }).style)
      end

      should "provide unique format keys" do
        assert_equal("currency_dollar_2_nocomma_blackparenth", Currency.new({
          :decimal_places => 2,
          :negative_numbers => :black_parenth,
          :comma_separator => false
        }).key)
        assert_equal("currency_none_4_comma_redparenth", Currency.new({
          :symbol => :none,
          :decimal_places => 4,
          :negative_numbers => :red_parenth,
          :comma_separator => true
        }).key)
      end



    end
  end

end
