require "test/helper"
require "test/mixins"

module Osheet

  class MixinBaseTest < Test::Unit::TestCase
    context "Osheet::Mixin thing" do
      subject { DefaultMixin }

      should_have_readers :styles, :templates, :partials
      should_have_instance_methods :style, :template, :partial

      should "set it's defaults" do
        assert_equal [], subject.styles
        assert_equal [], subject.templates
        assert_equal [], subject.partials
      end
    end
  end

  class MixinStyleTest < Test::Unit::TestCase
    context "that defines styles" do
      subject { StyledMixin }

      should "have it's styles defined" do
        assert_equal 2, subject.styles.size
        assert_equal 1, subject.styles.first.selectors.size
        assert_equal '.test', subject.styles.first.selectors.first
        assert_equal 1, subject.styles.last.selectors.size
        assert_equal '.test.awesome', subject.styles.last.selectors.first
      end
    end
  end

  class MixinTemplateTest < Test::Unit::TestCase
    context "that defines templates" do
      subject { TemplatedMixin }

      should "have it's templates defined" do
        assert subject.templates
        assert_equal 3, subject.templates.size
        assert_kind_of Template, subject.templates.first
      end
    end
  end

  class MixinPartialTest < Test::Unit::TestCase
    context "that defines partials" do
      subject { PartialedMixin }

      should "have it's partials defined" do
        assert subject.partials
        assert_equal 2, subject.partials.size
        assert_kind_of Partial, subject.partials.first
      end
    end
  end

  class MixinUseTest < Test::Unit::TestCase
    context "A workbook that uses mixins" do
      setup do
        @workbook = Osheet::Workbook.new do
          use PartialedMixin
          use TemplatedMixin
          use StyledMixin
        end
      end
      subject { @workbook }

      should "have mixin partials" do
        workbook_partials = @workbook.partials.values
        PartialedMixin.partials.each do |partial|
          assert workbook_partials.include?(partial)
        end
      end

      should "have mixin templates" do
        workbook_templates = @workbook.templates.values.collect{ |t| t.values.first }
        TemplatedMixin.templates.each do |template|
          assert workbook_templates.include?(template)
        end
      end

      should "have mixin styles" do
        assert_equal StyledMixin.styles, @workbook.styles
      end
    end
  end

end
