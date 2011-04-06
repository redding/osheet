require "test/helper"
require 'osheet/format/general'

module Osheet::Format

  class GeneralTest < Test::Unit::TestCase
    context "General format" do
      subject { General.new }

      should "always provide a nil style string" do
        assert_equal nil, subject.style
      end

      should "always provide and empty format key" do
        assert_equal '', subject.key
      end

    end
  end

end
