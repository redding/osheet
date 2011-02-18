require "test/helper"
require 'osheet/dsl/row'

class Osheet::Dsl::RowTest < Test::Unit::TestCase

  context "Osheet::Dsl::Row" do
    subject { Osheet::Dsl::Row.new }

    should_have_instance_method :cell

    should "set it's defaults" do
      assert_equal [], subject.send(:instance_variable_get, "@cells")
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
        cells = subject.send(:instance_variable_get, "@cells")
        assert !cells.empty?
        assert_equal 2, cells.size
        assert_kind_of Osheet::Dsl::Cell, cells.first
        assert_equal :text, cells.first.send(:instance_variable_get, "@format")
        assert_kind_of Osheet::Dsl::Cell, cells.last
        assert_equal :numeric, cells.last.send(:instance_variable_get, "@format")
      end
    end

  end

end
