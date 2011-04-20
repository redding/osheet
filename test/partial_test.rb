require "test/helper"
require "osheet/partial"

module Osheet
  class PartialTest < Test::Unit::TestCase

    context "Osheet::Partial" do
      subject do
        Partial.new(:thing) {}
      end

      should_have_accessor :name

      should "be a Proc" do
        assert_kind_of ::Proc, subject
      end

      should "convert the name arg to a string and store off" do
        assert_equal 'thing', subject.name
      end

    end
  end

  class PartialNameTest < Test::Unit::TestCase
    context "A named partial" do
      should "verify the name argument" do
        assert_raises ArgumentError do
          Partial.new([]) {}
        end
        assert_raises ArgumentError do
          Partial.new(1) {}
        end
        assert_nothing_raised do
          Partial.new(:poo) {}
        end
        assert_nothing_raised do
          Partial.new('poo') {}
        end
      end

    end
  end

  class PartialBindingTest < Test::Unit::TestCase
    context "a partial defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 'test thing'
        @workbook = Workbook.new {
          partial(:stuff) {
            worksheet(:thing) { name @test }
          }

          add(:stuff)
        }

        assert !@workbook.worksheets.first.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @workbook.worksheets.first.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @workbook.worksheets.first.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @workbook.worksheets.first.attributes[:name]
        assert_equal @test.object_id, @workbook.worksheets.first.attributes[:name].object_id
      end
    end
  end

end
