require "test/helper"
require 'osheet/format/general'

module Osheet::Format

  class GeneralTest < Test::Unit::TestCase
    context "General format" do
      subject { General.new }

      should "always provide a nil style string" do
        assert_equal nil, General.new.style
      end

    end
  end

end
