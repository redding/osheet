require "test/helper"

class Osheet::BaseTest < Test::Unit::TestCase

  context "Osheet::Base" do
    subject { Osheet::Base.new }

    should_have_instance_methods :class, :style

    should "default class to nil" do
      assert subject.class.nil?
    end

    should "default style to nil" do
      assert subject.style.nil?
    end

  end

end
