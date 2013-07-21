require "assert"
require 'osheet/format/custom'

class Osheet::Format::Custom

  class UnitTests < Assert::Context
    desc "Osheet::Format::Custom format"

    should "generate a basic style string and key" do
      f = Osheet::Format::Custom.new '@'
      assert_equal "@", f.style
      assert_equal "custom_@", f.key
    end

    should "generate a more complex style string and key" do
      f = Osheet::Format::Custom.new 'm/d/yy'
      assert_equal 'm/d/yy', f.style
      assert_equal "custom_m/d/yy", f.key
    end

  end

end
