require "assert"
require 'osheet/format/text'

class Osheet::Format::Text

  class UnitTests < Assert::Context
    desc "Text format"
    before{ @txt = Osheet::Format::Text.new }
    subject{ @txt }

    should "generate a style strings and key" do
      assert_equal "@", subject.style
      assert_equal "text", subject.key
    end

  end

end
