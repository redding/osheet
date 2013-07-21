require "assert"
require 'osheet/format/general'

class Osheet::Format::General

  class UnitTests < Assert::Context
    desc "Osheet::Format::General format"
    before{ @f = Osheet::Format::General.new }
    subject{ @f }

    should "always provide a nil style string" do
      assert_equal nil, subject.style
    end

    should "provide a format key" do
      assert_equal '', subject.key
    end

  end

end
