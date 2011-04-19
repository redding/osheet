require "test/helper"
require "osheet/template"

module Osheet
  class TemplateTest < Test::Unit::TestCase

    context "Osheet::Template" do
      subject do
        Template.new('column', :thing) { |a_thing|
          width 100
          meta(
            :thing => a_thing
          )
        }
      end

      should "define what elements it is valid for" do
        assert_equal ['worksheet', 'column', 'row', 'cell'], Template::ELEMENTS
      end

      should_have_accessors :element, :name

      should "be a Proc" do
        assert_kind_of ::Proc, subject
      end

      should "convert the element and name args to string and store off" do
        assert_equal 'column', subject.element
        assert_equal 'thing', subject.name
      end

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

      should "verify the name argument" do
        assert_raises ArgumentError do
          Template.new('worksheet', []) {}
        end
        assert_raises ArgumentError do
          Template.new('worksheet', 1) {}
        end
        assert_nothing_raised do
          Template.new('worksheet', :poo) {}
        end
        assert_nothing_raised do
          Template.new('worksheet', 'poo') {}
        end
      end
    end

  end

  class StyleBindingTest < Test::Unit::TestCase
    context "a template defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 'test thing'
        @workbook = Workbook.new {
          template('worksheet', :thing) { name @test }
          worksheet(:thing)
        }

        assert !@workbook.worksheets.first.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @workbook.worksheets.first.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @workbook.worksheets.first.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @workbook.worksheets.first.attributes[:name]
        assert_equal @test.object_id, @workbook.worksheets.first.attributes[:name].object_id
      end
    end
  end

end
