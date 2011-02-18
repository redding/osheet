require "test/helper"
require 'osheet/dsl/cell'

class Osheet::Dsl::CellTest < Test::Unit::TestCase

  context "Osheet::Dsl::Cell" do
    subject { Osheet::Dsl::Cell.new }

    should_have_instance_methods :data, :format, :colspan, :rowspan

    should "set it's defaults" do
      assert_equal nil, subject.send(:instance_variable_get, "@data")
      assert_equal nil, subject.send(:instance_variable_get, "@format")
      assert_equal 1,   subject.send(:instance_variable_get, "@colspan")
      assert_equal 1,   subject.send(:instance_variable_get, "@rowspan")
    end

    context "that has attributes" do
      subject do
        Osheet::Dsl::Cell.new do
          format  :text
          colspan 4
          rowspan 2
          data    "Poo"
        end
      end

      should "should set them correctly" do
        assert_equal "Poo", subject.send(:instance_variable_get, "@data")
        assert_equal :text, subject.send(:instance_variable_get, "@format")
        assert_equal 4,     subject.send(:instance_variable_get, "@colspan")
        assert_equal 2,     subject.send(:instance_variable_get, "@rowspan")
      end
    end

  end

end
