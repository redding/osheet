require "test/helper"
require "osheet/template"

module Osheet

  class TemplateTest < Test::Unit::TestCase
    context "Osheet::Template" do
      subject do
        Template.new('column', :thing) {}
      end

      should "define what elements it is valid for" do
        assert_equal ['worksheet', 'column', 'row', 'cell'], Template::ELEMENTS
      end

      should_have_accessor :element

      should "be a Partial" do
        assert_kind_of Partial, subject
      end

      should "convert the element ars to string and store off" do
        assert_equal 'column', subject.element
      end

    end
  end

  class TemplateElementTest < Test::Unit::TestCase
    context "a template" do
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

  # class TemplateBindingTest < Test::Unit::TestCase
  #   context "a template defined w/ a block" do
  #     should "access instance vars from that block's binding" do
  #       @test = 'test thing'
  #       @workbook = Workbook.new {
  #         template('worksheet', :thing) { name @test }
  #         worksheet(:thing)
  #       }
  #
  #       assert !@workbook.worksheets.first.send(:instance_variable_get, "@test").nil?
  #       assert_equal @test, @workbook.worksheets.first.send(:instance_variable_get, "@test")
  #       assert_equal @test.object_id, @workbook.worksheets.first.send(:instance_variable_get, "@test").object_id
  #       assert_equal @test, @workbook.worksheets.first.attributes[:name]
  #       assert_equal @test.object_id, @workbook.worksheets.first.attributes[:name].object_id
  #     end
  #   end
  # end

end
