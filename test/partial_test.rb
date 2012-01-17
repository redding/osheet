require "assert"

require "osheet/partial"

module Osheet
  class PartialTest < Assert::Context
    desc "a Partial"
    before { @p = Partial.new(:thing) {} }
    subject { @p }

    should "be a Proc" do
      assert_kind_of ::Proc, subject
    end

    should "convert the name arg to a string and store off" do
      assert_equal 'thing', subject.instance_variable_get("@name")
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

end
