require "test/helper"
require "test/mixins"

module Osheet

  class MixinBaseTest < Test::Unit::TestCase
    context "Osheet::Mixin thing" do
      subject { DefaultMixin }

      should_have_readers :styles, :templates
      should_have_instance_methods :style, :template

      should "set it's defaults" do
        assert_equal [], subject.styles
        assert_equal [], subject.templates
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

end
