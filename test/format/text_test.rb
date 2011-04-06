require "test/helper"
require 'osheet/format/text'

module Osheet::Format

  class TextTest < Test::Unit::TestCase
    context "Text format" do
      subject { Text.new }

      should "generate a style strings and key" do
        assert_equal "@", subject.style
        assert_equal "text", subject.key
      end

    end
  end

end
