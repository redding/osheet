require "test/helper"
require "osheet/dsl/base"

class Osheet::Dsl::BaseTest < Test::Unit::TestCase

  context "Osheet::Dsl::Base" do
    subject { Osheet::Dsl::Base.new }
    before { Osheet::Dsl::Base.defaults }

    should_have_instance_method :style
    should_have_class_method :defaults

    should "default style to nil" do
      assert_equal nil, subject.style_value
    end

  end

end
