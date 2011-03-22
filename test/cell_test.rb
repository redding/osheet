require "test/helper"
require 'osheet/cell'

module Osheet
  class CellTest < Test::Unit::TestCase

    context "Osheet::Cell" do
      subject { Cell.new }

      should_be_a_styled_element(Cell)

      should_have_instance_methods :data, :format, :colspan, :rowspan, :href

      should "set it's defaults" do
        assert_equal nil, subject.send(:instance_variable_get, "@data")
        assert_equal nil, subject.send(:instance_variable_get, "@format")
        assert_equal 1,   subject.send(:instance_variable_get, "@colspan")
        assert_equal 1,   subject.send(:instance_variable_get, "@rowspan")
        assert_equal nil,   subject.send(:instance_variable_get, "@href")
      end

      context "that has attributes" do
        subject do
          Cell.new do
            data    "Poo"
            format  '@'
            colspan 4
            rowspan 2
            href "http://www.google.com"
          end
        end

        should "should set them correctly" do
          assert_equal "Poo", subject.send(:instance_variable_get, "@data")
          assert_equal '@', subject.send(:instance_variable_get, "@format")
          assert_equal 4,     subject.send(:instance_variable_get, "@colspan")
          assert_equal 2,     subject.send(:instance_variable_get, "@rowspan")
          assert_equal "http://www.google.com", subject.send(:instance_variable_get, "@href")
        end
      end

      should "type cast data strings/symbols" do
        ['a string', :symbol].each do |thing|
          cell = Cell.new{data thing}
          assert_kind_of ::String, cell.send(:instance_variable_get, "@data")
        end
      end
      should "type cast data dates" do
        cell = Cell.new{data Date.today}
        assert_kind_of ::Date, cell.send(:instance_variable_get, "@data")
      end
      should "type cast data numerics" do
        [1, 1.0].each do |thing|
          cell = Cell.new{data thing}
          assert_kind_of ::Numeric, cell.send(:instance_variable_get, "@data")
        end
      end
      should "type cast all other data to string" do
        [Osheet, [:a, 'Aye'], {:a => 'Aye'}].each do |thing|
          cell = Cell.new{data thing}
          assert_kind_of ::String, cell.send(:instance_variable_get, "@data")
        end
      end

      should "type cast the format to always be a string" do
        ['string', 1, 1.0, true, :symbol, [1,2], {:a => 'qye'}, Osheet].each do |thing|
          cell = Cell.new{format thing}
          assert_kind_of ::String, cell.send(:instance_variable_get, "@format")
        end
      end


    end

  end
end
