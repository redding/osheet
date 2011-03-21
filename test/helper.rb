require 'rubygems'
require 'test_belt'
require 'test/env'


class Test::Unit::TestCase
  class << self

    def should_be_a_styled_element(klass)
      should_have_instance_methods :style_class

      context "by default" do
        before { @default = klass.new }
        should "default an empty style class" do
          assert_equal nil, @default.send(:instance_variable_get, "@style_class")
        end
      end

      context "with a style class" do
        before { @styled = klass.new{ style_class "awesome thing" } }
        should "default an empty style class" do
          assert_equal "awesome thing", @styled.send(:instance_variable_get, "@style_class")
        end
      end
    end

    def should_hm(klass, collection, item_klass)
      should_have_reader collection
      should_have_instance_method collection.to_s.sub(/s$/, '')

      subject do
      end

      should "should initialize and add them to it's collection" do
        singular = collection.to_s.sub(/s$/, '')
        thing = klass.new do
          self.send(singular) {}
        end

        items = thing.send(:instance_variable_get, "@cells")
        assert_equal items, thing.send(collection)
        assert !items.empty?
        assert_equal 1, items.size
        assert_kind_of item_klass, items.first
      end

    end

  end
end