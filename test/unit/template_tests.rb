require "assert"
require "osheet/template"

require 'osheet/partial'

class Osheet::Template

  class UnitTests < Assert::Context
    desc "Osheet::Template"
    before do
      @tmpl = Osheet::Template.new('column', :thing) {}
    end
    subject { @tmpl }

    should have_reader :element

    should "define what elements it is valid for" do
      assert_equal ['worksheet', 'column', 'row', 'cell'], Osheet::Template::ELEMENTS
    end

    should "be a Partial" do
      assert_kind_of Osheet::Partial, subject
    end

    should "convert the element ars to string and store off" do
      assert_equal 'column', subject.instance_variable_get("@element")
    end

  end

  class TemplateElementTest < UnitTests
    desc "a template"

    should "verify the element argument" do
      assert_raises ArgumentError do
        Osheet::Template.new({}, :poo) {}
      end

      assert_raises ArgumentError do
        Osheet::Template.new('workbook', :poo) {}
      end

      Osheet::Template::ELEMENTS.each do |elem|
        assert_nothing_raised do
          Osheet::Template.new(elem, :poo) {}
        end
      end
    end

  end

end
