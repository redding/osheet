require "test/helper"
require "osheet/style_set"

module Osheet
  class StyleSetTest < Test::Unit::TestCase

    context "Osheet::StyleSet" do
      subject { StyleSet.new }

      should "be an Array" do
        assert_kind_of ::Array, subject
      end

      should_have_reader :for

      should "verify Template objs" do
        assert_raises ArgumentError do
          subject.send(:verify, {})
        end
        assert_nothing_raised do
          subject.send(:verify, Style.new('.awesome') {})
        end
      end

      should "be able to lookup styles by class" do
        subject << (a = Style.new('.awesome') {})
        subject << (at = Style.new('.awesome.thing') {})
        subject << (b = Style.new('.boring') {})
        subject << (bt = Style.new('.boring.thing') {})
        subject << (a_b = Style.new('.awesome', '.boring') {})
        subject << (t = Style.new('.thing') {})
        subject << (s = Style.new('.stupid') {})

        { 'awesome' => [a, a_b],
          'boring' => [b, a_b],
          'thing' => [t],
          'awesome thing' => [a, at, a_b, t],
          'thing awesome' => [a, at, a_b, t],
          'other' => []
        }.each do |style_class, styles_set|
          if style_class == 'awesome'
            assert_equal styles_set, subject.for(style_class)
          end
        end
      end

    end

  end
end
