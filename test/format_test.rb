require "test/helper"
require 'osheet/format'

module Osheet

  class Format_APITest < Test::Unit::TestCase
    context "Osheet::Format api" do
      subject { Format.new }

      should_have_instance_methods :value, :options, :style
    end
  end

  class Format_GeneralTest < Test::Unit::TestCase
    context "General format" do
      subject { Format.new }

      should "set it's values (and be the default)" do
        assert_equal :general, subject.value
        assert_equal({}, subject.options)
        assert_equal nil,   subject.style
      end

      should "complain about invalid format values" do
        assert_raises ArgumentError do
          Format.new(:poo)
        end
      end
    end
  end

  class Format_NumberTest < Test::Unit::TestCase
    context "Number format" do
      subject { Format.new :number }

      should "set default options" do
        assert_equal({
          :decimal_places => 0,
          :comma_separator => false,
          :display_negatives => :black
        }, subject.options)
      end

      should "only allow positive Fixnum decimal places" do
        assert_raises ArgumentError do
          Format.new(:number, {:decimal_places => -1})
        end
        assert_raises ArgumentError do
          Format.new(:number, {:decimal_places => 'poo'})
        end
        assert_nothing_raised do
          Format.new(:number, {:decimal_places => 1})
        end
      end
    end
  end

end
