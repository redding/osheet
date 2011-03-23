require "test/helper"
require "osheet/style"

module Osheet
  class StyleTest < Test::Unit::TestCase

    context "Osheet::Style" do
      subject { Style.new }

      should_have_instance_methods :align, :font, :bg_color, :bg_pattern
      should_have_instance_methods :border, :border_left, :border_top, :border_right, :border_bottom

      should "set it's defaults" do
        [ :align, :font, :bg_color, :bg_pattern,
          :border_left, :border_top, :border_right, :border_bottom
        ].each do |a|
          assert_equal [], subject.send(:instance_variable_get, "@#{a}")
        end
      end

      [ :align, :font, :bg_color, :bg_pattern,
        :border_left, :border_top, :border_right, :border_bottom
      ].each do |a|
        should "collect styles for #{a}" do
          args = [1, "#FF0000", "Verdana", :love, 1.2]
          subject.send(a, *args)
          assert_equal args, subject.send(:instance_variable_get, "@#{a}")
        end
      end

      should "set all border positions to the same styles using 'border' macro" do
        args = [:thick, '#FF00FF', :dot]
        subject.border *args
        [ :border_left, :border_top, :border_right, :border_bottom].each do |a|
          assert_equal args, subject.send(:instance_variable_get, "@#{a}")
        end
      end
    end

  end
end
