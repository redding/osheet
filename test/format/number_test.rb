require "test/helper"
require 'osheet/format/number'

module Osheet::Format

  class NumberTest < Test::Unit::TestCase
    context "Number format" do
      subject { Number.new }

      should_have_accessors :decimal_places, :comma_separator, :negative_numbers

      should "provide options for negative numbers" do
        assert_equal 4, Number.negative_numbers_set.size
        [:black, :black_parenth, :red, :red_parenth].each do |a|
          assert Number.negative_numbers_set.include?(a)
        end
      end

      should "set default values" do
        assert_equal 0, subject.decimal_places
        assert_equal false, subject.comma_separator
        assert_equal :black, subject.negative_numbers
      end

      should "only allow Fixnum decimal places between 0 and 30" do
        assert_raises ArgumentError do
          Number.new({:decimal_places => -1})
        end
        assert_raises ArgumentError do
          Number.new({:decimal_places => 31})
        end
        assert_raises ArgumentError do
          Number.new({:decimal_places => 'poo'})
        end
        assert_nothing_raised do
          Number.new({:decimal_places => 1})
        end
      end

      should "generate decimal place style strings" do
        assert_equal "0", Number.new({:decimal_places => 0}).style
        (1..5).each do |n|
          assert_equal "0.#{'0'*n}", Number.new({:decimal_places => n}).style
        end
      end

      should "generate comma separator style strings" do
        assert_equal "0", Number.new({:comma_separator => false}).style
        assert_equal "#,##0", Number.new({:comma_separator => true}).style
      end

      should "generate parenth negative numbers style strings" do
        assert_equal "0", Number.new({:negative_numbers => :black}).style
        assert_equal "0_);\(0\)", Number.new({:negative_numbers => :black_parenth}).style
      end

      should "generate red negative numbers style strings" do
        assert_equal "0;[Red]0", Number.new({:negative_numbers => :red}).style
        assert_equal "0_);[Red]\(0\)", Number.new({:negative_numbers => :red_parenth}).style
      end

      should "generate complex style string" do
        assert_equal("0.00_);\(0.00\)", Number.new({
          :decimal_places => 2,
          :negative_numbers => :black_parenth,
          :comma_separator => false
        }).style)
        assert_equal("#,##0.0000_);[Red]\(#,##0.0000\)", Number.new({
          :decimal_places => 4,
          :negative_numbers => :red_parenth,
          :comma_separator => true
        }).style)
      end

      should "provide unique format keys" do
        assert_equal("number_2_nocomma_blackparenth", Number.new({
          :decimal_places => 2,
          :negative_numbers => :black_parenth,
          :comma_separator => false
        }).key)
        assert_equal("number_4_comma_redparenth", Number.new({
          :decimal_places => 4,
          :negative_numbers => :red_parenth,
          :comma_separator => true
        }).key)
      end



    end
  end

end
