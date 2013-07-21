require "assert"
require 'osheet/format/percentage'

class Osheet::Format::Percentage

  class UnitTests < Assert::Context
    desc "Osheet::Format::Percentage format"
    before{ @p = Osheet::Format::Percentage.new }
    subject{ @p }

    should have_accessors :decimal_places, :symbol, :comma_separator, :negative_numbers

    should "provide negative numbers options" do
      assert_equal 4, Osheet::Format::Percentage.negative_numbers_set.size
      [:black, :black_parenth, :red, :red_parenth].each do |a|
        assert Osheet::Format::Percentage.negative_numbers_set.include?(a)
      end
    end

    should "set default values" do
      assert_equal 2, subject.decimal_places
      assert_equal false, subject.comma_separator
      assert_equal 'black', subject.negative_numbers
    end

    should "only allow Fixnum decimal places between 0 and 30" do
      assert_raises ArgumentError do
        Osheet::Format::Percentage.new({:decimal_places => -1})
      end

      assert_raises ArgumentError do
        Osheet::Format::Percentage.new({:decimal_places => 31})
      end

      assert_raises ArgumentError do
        Osheet::Format::Percentage.new({:decimal_places => 'poo'})
      end

      assert_nothing_raised do
        Osheet::Format::Percentage.new({:decimal_places => 1})
      end
    end

    should "generate decimal place style strings" do
      assert_equal "0%", Osheet::Format::Percentage.new({
        :decimal_places => 0
      }).style

      (1..5).each do |n|
        assert_equal "0.#{'0'*n}%", Osheet::Format::Percentage.new({
          :decimal_places => n
        }).style
      end
    end

    should "generate comma separator style strings" do
      assert_equal "0%", Osheet::Format::Percentage.new({
        :comma_separator => false,
        :decimal_places => 0
      }).style

      assert_equal "#,##0%", Osheet::Format::Percentage.new({
        :comma_separator => true,
        :decimal_places => 0
      }).style
    end

    should "generate parenth negative numbers style strings" do
      assert_equal "0%", Osheet::Format::Percentage.new({
        :negative_numbers => :black,
        :decimal_places => 0
      }).style

      assert_equal "0%_);\(0%\)", Osheet::Format::Percentage.new({
        :negative_numbers => :black_parenth,
        :decimal_places => 0
      }).style
    end

    should "generate red negative numbers style strings" do
      assert_equal "0%;[Red]0%", Osheet::Format::Percentage.new({
        :negative_numbers => :red,
        :decimal_places => 0
      }).style

      assert_equal "0%_);[Red]\(0%\)", Osheet::Format::Percentage.new({
        :negative_numbers => :red_parenth,
        :decimal_places => 0
      }).style
    end

    should "generate complex style string" do
      assert_equal("0.00%_);\(0.00%\)", Osheet::Format::Percentage.new({
        :decimal_places => 2,
        :negative_numbers => :black_parenth,
        :comma_separator => false
      }).style)

      assert_equal("#,##0.0000%_);[Red]\(#,##0.0000%\)", Osheet::Format::Percentage.new({
        :decimal_places => 4,
        :negative_numbers => :red_parenth,
        :comma_separator => true
      }).style)
    end

    should "provide unique format keys" do
      assert_equal("percentage_none_2_nocomma_blackparenth", Osheet::Format::Percentage.new({
        :decimal_places => 2,
        :negative_numbers => :black_parenth,
        :comma_separator => false
      }).key)

      assert_equal("percentage_none_4_comma_redparenth", Osheet::Format::Percentage.new({
        :symbol => :none,
        :decimal_places => 4,
        :negative_numbers => :red_parenth,
        :comma_separator => true
      }).key)
    end

  end

end
