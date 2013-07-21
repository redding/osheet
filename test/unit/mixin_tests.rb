require "assert"
require 'osheet/mixin'

require "test/support/mixins"

module Osheet::Mixin

  class UnitTests < Assert::Context
    desc "a mixin"
    subject { DefaultMixin }

    should have_readers :styles, :templates, :partials
    should have_instance_methods :style, :template, :partial

    should "set it's defaults" do
      assert_equal [], subject.styles
      assert_equal [], subject.templates
      assert_equal [], subject.partials
    end
  end

  class MixinArgsTests < UnitTests
    desc "args class"
    before do
      @build_block = Proc.new {}
      @ma = Osheet::Mixin::Args.new('some', 'args', 'here', &@build_block)
    end
    subject { @ma }

    should have_readers :args, :build

    should "collect arguments" do
      assert_equal ['some', 'args', 'here'], subject.args
    end

    should "store a build block" do
      assert_same @build_block, subject.build
    end

    should "default with empty args and an empty Proc build" do
      default = Osheet::Mixin::Args.new

      assert_empty default.args
      assert_kind_of Proc, default.build
    end

  end

  class MixinStyleTests < Assert::Context
    desc "that defines styles"
    subject { StyledMixin }

    should "have it's styles defined" do
      assert_equal 2, subject.styles.size
      assert_kind_of Osheet::Mixin::Args, subject.styles.first
    end
  end

  class MixinTemplateTests < Assert::Context
    desc "that defines templates"
    subject { TemplatedMixin }

    should "have it's templates defined" do
      assert subject.templates
      assert_equal 3, subject.templates.size
      assert_kind_of Osheet::Mixin::Args, subject.templates.first
    end
  end

  class MixinPartialTests < Assert::Context
    desc "that defines partials"
    subject { PartialedMixin }

    should "have it's partials defined" do
      assert subject.partials
      assert_equal 2, subject.partials.size
      assert_kind_of Osheet::Mixin::Args, subject.partials.first
    end
  end

end
