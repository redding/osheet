require 'rubygems'
require 'test_belt'
require 'test/env'


class Test::Unit::TestCase
  class << self

    def should_be_a_styled_element(klass)
      should_have_instance_methods :style_class

      default = klass.new
      should "default an empty style class" do
        assert_equal nil, default.send(:instance_variable_get, "@style_class")
      end

      styled = klass.new{ style_class "awesome thing" }
      should "default an empty style class" do
        assert_equal "awesome thing", styled.send(:instance_variable_get, "@style_class")
      end
    end

  end
end