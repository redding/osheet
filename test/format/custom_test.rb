require "test/helper"
require 'osheet/format/custom'

module Osheet::Format

  class CustomTest < Test::Unit::TestCase
    context "Custom format" do
      should "generate a basic style string and key" do
        f = Custom.new '@'
        assert_equal "@", f.style
        assert_equal "custom_@", f.key
      end

      should "generate a more complex style string and key" do
        f = Custom.new 'm/d/yy'
        assert_equal 'm/d/yy', f.style
        assert_equal "custom_m/d/yy", f.key
      end
    end
  end

end
