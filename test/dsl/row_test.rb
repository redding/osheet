require "test/helper"
require 'osheet/dsl/row'

class Osheet::Dsl::RowTest < Test::Unit::TestCase

  context "Osheet::Dsl::Row" do
    subject { Osheet::Dsl::Row.new }

    should_have_instance_method :cell

    should "set it's defaults" do
      assert_equal [], subject.cells_set
    end

    context "that has some cells" do
      subject do
        Osheet::Dsl::Row.new do
          cell do
            format  :text
            colspan 4
            rowspan 2
            data    "Poo"
          end

          cell do
            format  :numeric
            data    1
          end
        end
      end

      should "should initialize and add them to it's collection" do
        cells = subject.cells_set
        assert !cells.empty?
        assert_equal 2, cells.size
        assert_equal :text, cells.first.format_value
        assert_equal :numeric, cells.last.format_value
      end
    end

  end

end
