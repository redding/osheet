require "assert"
require 'osheet/mixin'

require "osheet/assert_test_helpers"
require 'osheet/workbook'
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
    include Osheet::AssertTestHelpers

    desc "that defines styles"
    subject { StyledMixin }

    should "have it's styles defined" do
      assert_equal 2, subject.styles.size
      assert_kind_of Osheet::Mixin::Args, subject.styles.first
    end

    should "apply to a workbook" do
      workbook = Osheet::Workbook.new{ use StyledMixin }

      assert_equal 2, workbook.styles.size
      test, test_awesome = workbook.styles

      assert_style test, ['.test']
      assert_style test_awesome, ['.test.awesome']
    end

  end

  class MixinTemplateTests < Assert::Context
    include Osheet::AssertTestHelpers

    desc "that defines templates"
    subject { TemplatedMixin }

    should "have it's templates defined" do
      assert subject.templates
      assert_equal 3, subject.templates.size
      assert_kind_of Osheet::Mixin::Args, subject.templates.first
    end

    should "apply to a workbook" do
      workbook = Osheet::Workbook.new{ use TemplatedMixin }

      assert_equal 3, workbook.templates.size

      assert_template workbook.templates, :column, :yo
      assert_template workbook.templates, :row, :yo_yo
      assert_template workbook.templates, :worksheet, :go
    end

  end

  class MixinPartialTests < Assert::Context
    include Osheet::AssertTestHelpers

    desc "that defines partials"
    subject { PartialedMixin }

    should "have it's partials defined" do
      assert subject.partials
      assert_equal 2, subject.partials.size
      assert_kind_of Osheet::Mixin::Args, subject.partials.first
    end

    should "apply to a workbook" do
      workbook = Osheet::Workbook.new{ use PartialedMixin }

      assert_equal 2, workbook.partials.size

      assert_partial workbook.partials, :three_empty_rows
      assert_partial workbook.partials, :two_cells_in_a_row
    end

  end

end
