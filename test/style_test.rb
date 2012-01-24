require "assert"

require "osheet/style"

module Osheet

  class StyleTest < Assert::Context
    desc "a Style"
    before { @st = Style.new('.test') }
    subject { @st }

    should have_reader :selectors, :build
    should have_instance_methods :align, :font, :bg, :border
    should have_instance_methods :border_left, :border_top
    should have_instance_methods :border_right, :border_bottom
    should have_instance_method :match?

    should "set it's defaults" do
      assert_equal 1, subject.selectors.size
      assert_equal '.test', subject.selectors.first
      [ :align, :font, :bg,
        :border_left, :border_top, :border_right, :border_bottom
      ].each do |a|
        assert_equal [], subject.send(a)
      end
    end

    should "complain about bad selectors" do
      ['poo', '#poo', 'poo poo', 'poo > poo', :poo, 123].each do |s|
        assert_raises ArgumentError do
          Style.new(s)
        end
      end
    end

    should "not complain about good selectors" do
      ['.poo', '.poo.poo', '.poo-poo', '.poo_poo'].each do |s|
        assert_nothing_raised do
          Style.new(s)
        end
      end
    end

    [ :align, :font, :bg,
      :border_left, :border_top, :border_right, :border_bottom
    ].each do |a|
      should "collect styles for #{a}" do
        args = [1, "#FF0000", "Verdana", :love, 1.2]
        subject.send(a, *args)
        assert_equal args, subject.send(a)
      end
    end

    should "set all border positions to the same styles using 'border' macro collector" do
      args = [:thick, '#FF00FF', :dot]
      subject.border *args
      [ :border_left, :border_top, :border_right, :border_bottom].each do |a|
        assert_equal args, subject.send(a)
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
