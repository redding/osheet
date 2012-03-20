require "assert"
require 'osheet/format/general'

module Osheet::Format

  class GeneralTest < Assert::Context
    desc "General format"
    before { @f = General.new }
    subject { @f }

    should "always provide a nil style string" do
      assert_equal nil, subject.style
    end

    should "provide a format key" do
      assert_equal '', subject.key
    end

  end

end
