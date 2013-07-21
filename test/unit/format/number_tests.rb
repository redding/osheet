require "assert"
require 'osheet/format/number'

class Osheet::Format::Number

  class UnitTests < Assert::Context
    desc "Osheet::Format::Number format"
    before{ @n = Osheet::Format::Number.new }
    subject{ @n }

    should have_accessors :decimal_places, :comma_separator, :negative_numbers

    should "provide options for negative numbers" do
      assert_equal 4, Osheet::Format::Number.negative_numbers_set.size
      [:black, :black_parenth, :red, :red_parenth].each do |a|
        assert Osheet::Format::Number.negative_numbers_set.include?(a)
      end
    end

    should "set default values" do
      assert_equal 0, subject.decimal_places
      assert_equal false, subject.comma_separator
      assert_equal 'black', subject.negative_numbers
    end

    should "only allow Fixnum decimal places between 0 and 30" do
      assert_raises ArgumentError do
        Osheet::Format::Number.new({:decimal_places => -1})
      end

      assert_raises ArgumentError do
        Osheet::Format::Number.new({:decimal_places => 31})
      end

      assert_raises ArgumentError do
        Osheet::Format::Number.new({:decimal_places => 'poo'})
      end

      assert_nothing_raised do
        Osheet::Format::Number.new({:decimal_places => 1})
      end
    end

    should "generate decimal place style strings" do
      assert_equal "0", Osheet::Format::Number.new({:decimal_places => 0}).style
      (1..5).each do |n|
        assert_equal "0.#{'0'*n}", Osheet::Format::Number.new({:decimal_places => n}).style
      end
    end

    should "generate comma separator style strings" do
      assert_equal "0",     Osheet::Format::Number.new({:comma_separator => false}).style
      assert_equal "#,##0", Osheet::Format::Number.new({:comma_separator => true}).style
    end

    should "generate parenth negative numbers style strings" do
      assert_equal "0",         Osheet::Format::Number.new({:negative_numbers => :black}).style
      assert_equal "0_);\(0\)", Osheet::Format::Number.new({:negative_numbers => :black_parenth}).style
    end

    should "generate red negative numbers style strings" do
      assert_equal "0;[Red]0",       Osheet::Format::Number.new({:negative_numbers => :red}).style
      assert_equal "0_);[Red]\(0\)", Osheet::Format::Number.new({:negative_numbers => :red_parenth}).style
    end

    should "generate complex style string" do
      assert_equal("0.00_);\(0.00\)", Osheet::Format::Number.new({
        :decimal_places => 2,
        :negative_numbers => :black_parenth,
        :comma_separator => false
      }).style)

      assert_equal("#,##0.0000_);[Red]\(#,##0.0000\)", Osheet::Format::Number.new({
        :decimal_places => 4,
        :negative_numbers => :red_parenth,
        :comma_separator => true
      }).style)
    end

    should "provide unique format keys" do
      assert_equal("number_none_2_nocomma_blackparenth", Osheet::Format::Number.new({
        :decimal_places => 2,
        :negative_numbers => :black_parenth,
        :comma_separator => false
      }).key)

      assert_equal("number_none_4_comma_redparenth", Osheet::Format::Number.new({
        :decimal_places => 4,
        :negative_numbers => :red_parenth,
        :comma_separator => true
      }).key)
    end

  end

end
