require "assert"
require 'osheet/format/text'

module Osheet::Format

  class TextTest < Assert::Context
    desc "Text format"
    before { @txt = Text.new }
    subject { @txt }

    should "generate a style strings and key" do
      assert_equal "@", subject.style
      assert_equal "text", subject.key
    end

  end

end
