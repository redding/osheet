require 'rubygems'
require 'test_belt'
require 'test/env'

class Test::Unit::TestCase
  class << self

    def should_be_a_worksheet_element(klass)
      should_have_instance_methods :worksheet, :columns
      context "given a worksheet" do
        before do
          @wksht = Osheet::Worksheet.new {
            column {}
            column {}
            column {}
          }
          @klass = klass.new(@wksht)
        end

        should "be able to access the worksheet" do
          assert_equal @wksht, @klass.worksheet
          assert_equal @wksht.columns, @klass.columns
        end
      end
    end

    def should_be_a_styled_element(klass)
      should_have_instance_methods :style_class

      context "by default" do
        before { @default = klass.new }
        should "default an empty style class" do
          assert_equal nil, @default.send(:instance_variable_get, "@style_class")
        end
      end

      should "default an empty style class" do
        styled = klass.new{ style_class "awesome thing" }
        assert_equal "awesome thing", styled.send(:instance_variable_get, "@style_class")
      end

      should "verify the style class string" do
        ['.thing', 'thing.thing', 'thing .thing > thing', 'thin>g'].each do |s|
          assert_raises ArgumentError do
            klass.new { style_class s }
          end
        end
        ['thing', '#thing 123', 'thing-one thing_one'].each do |s|
          assert_nothing_raised do
            klass.new { style_class s }
          end
        end
      end
    end

    def should_hm(klass, collection, item_klass)
      should_have_reader collection
      should_have_instance_method collection.to_s.sub(/s$/, '')

      subject do
      end

      should "should initialize #{collection} and add them to it's collection" do
        singular = collection.to_s.sub(/s$/, '')
        thing = klass.new do
          self.send(singular) {}
        end

        items = thing.send(:instance_variable_get, "@#{collection}")
        assert_equal items, thing.send(collection)
        assert !items.empty?
        assert_equal 1, items.size
        assert_kind_of item_klass, items.first
      end

    end

  end
end