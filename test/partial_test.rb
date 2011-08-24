require "assert"
require "osheet/partial"

module Osheet
  class PartialTest < Assert::Context
    desc "Osheet::Partial"
    before { @p = Partial.new(:thing) {} }
    subject { @p }

    should have_accessor :name

    should "be a Proc" do
      assert_kind_of ::Proc, subject
    end

    should "convert the name arg to a string and store off" do
      assert_equal 'thing', subject.name
    end

  end

  class PartialNameTest < Assert::Context
    desc "A named partial"

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

  class PartialBindingTest < Assert::Context
    desc "a partial defined w/ a block"

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
