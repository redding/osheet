require "test/helper"
require "osheet/style"

module Osheet
  class StyleTest < Test::Unit::TestCase

    context "Osheet::Style" do
      subject { Style.new('.test') }

      should_have_reader :selectors
      should_have_instance_methods :align, :font, :bg
      should_have_instance_methods :border, :border_left, :border_top, :border_right, :border_bottom
      should_have_instance_method :match?

      should "verify the selector" do
        ['poo', '#poo', 'poo poo', 'poo > poo', :poo, 123].each do |s|
          assert_raises ArgumentError do
            Style.new(s)
          end
        end
        ['.poo', '.poo.poo', '.poo-poo', '.poo_poo'].each do |s|
          assert_nothing_raised do
            Style.new(s)
          end
        end
      end

      should "set it's defaults" do
        assert_equal 1, subject.selectors.size
        assert_equal '.test', subject.selectors.first
        [ :align, :font, :bg,
          :border_left, :border_top, :border_right, :border_bottom
        ].each do |a|
          assert_equal [], subject.send(:get_ivar, a)
        end
      end

      should "know it's attribute(s)" do
        [ :align, :font, :bg,
          :border_left, :border_top, :border_right, :border_bottom
        ].each do |a|
          assert subject.attributes.has_key?(a)
        end
      end



      [ :align, :font, :bg,
        :border_left, :border_top, :border_right, :border_bottom
      ].each do |a|
        should "collect styles for #{a}" do
          args = [1, "#FF0000", "Verdana", :love, 1.2]
          subject.send(a, *args)
          assert_equal args, subject.send(:get_ivar, a)
        end
      end

      should "set all border positions to the same styles using 'border' macro" do
        args = [:thick, '#FF00FF', :dot]
        subject.border *args
        [ :border_left, :border_top, :border_right, :border_bottom].each do |a|
          assert_equal args, subject.send(:get_ivar, a)
        end
      end

      should "match on style class strings" do
        a = Style.new('.awesome') {}
        at = Style.new('.awesome.thing') {}
        b = Style.new('.boring') {}
        bt = Style.new('.boring.thing') {}
        a_b = Style.new('.awesome', '.boring') {}
        t = Style.new('.thing') {}
        s = Style.new('.stupid') {}

        { 'awesome' => [a, a_b],
          'boring' => [b, a_b],
          'thing' => [t],
          'awesome thing' => [a, at, a_b, t],
          'thing awesome' => [a, at, a_b, t],
          'other' => []
        }.each do |style_class, styles|
          styles.each do |style|
            assert_equal true, style.match?(style_class)
          end
        end
        assert_equal false, a.match?('stupid')
      end

    end

  end

  class StyleBindingTest < Test::Unit::TestCase
    context "a style defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 20
        @style = Style.new('.test') { font @test }

        assert !@style.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @style.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @style.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @style.attributes[:font].first
        assert_equal @test.object_id, @style.attributes[:font].first.object_id
      end
    end
  end

end
