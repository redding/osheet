require "assert"
require "osheet/template"

module Osheet

  class TemplateTest < Assert::Context
    desc "Osheet::Template"
    before do
      @tmpl = Template.new('column', :thing) {}
    end
    subject { @tmpl }

    should "define what elements it is valid for" do
      assert_equal ['worksheet', 'column', 'row', 'cell'], Template::ELEMENTS
    end

    should have_accessor :element

    should "be a Partial" do
      assert_kind_of Partial, subject
    end

    should "convert the element ars to string and store off" do
      assert_equal 'column', subject.element
    end

  end

  class TemplateElementTest < TemplateTest
    desc "a template"

    should "verify the element argument" do
      assert_raises ArgumentError do
        Template.new({}, :poo) {}
      end
      assert_raises ArgumentError do
        Template.new('workbook', :poo) {}
      end
      Template::ELEMENTS.each do |elem|
        assert_nothing_raised do
          Template.new(elem, :poo) {}
        end
      end
    end

  end

end
