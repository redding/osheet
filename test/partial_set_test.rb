require "test/helper"
require "osheet/partial_set"

module Osheet

  class PartialSetTest < Test::Unit::TestCase
    context "Osheet::PartialSet" do
      subject { PartialSet.new }

      should "be a Hash" do
        assert_kind_of ::Hash, subject
      end

      should_have_instance_method :<<
      should_have_reader :get

      should "verify set objs are partials" do
        assert_raises ArgumentError do
          subject.send(:verify, {})
        end
        assert_nothing_raised do
          subject.send(:verify, Partial.new(:poo) {})
        end
      end

    end
  end

  class PartialSetKeyTest < Test::Unit::TestCase
    context "A partial set" do
      subject { PartialSet.new }

      should "key using name values" do
        assert_equal 'poo', subject.send(:key, :poo)
      end

      should "key on partial objs" do
        assert_equal 'poo', subject.send(:partial_key, Partial.new(:poo) {})
      end

      should "init the key in the set when verifying" do
        key = subject.send(:verify, Partial.new(:thing) {})
        assert_equal 'thing', key
        assert_equal({'thing' => nil}, subject)
      end

    end
  end

  class PartialSetPushTest < Test::Unit::TestCase
    context "A partial set" do
      subject { PartialSet.new }
      should "push partials onto the set" do
        assert_nothing_raised do
          subject << Partial.new(:poo) {}
          subject << Partial.new(:not_poo) {}
          subject << Partial.new(:awesome) {}
          subject << Partial.new(:poo) {}
        end

        assert_equal 3, subject.keys.size
        assert subject["poo"]
        assert_kind_of Partial, subject["poo"]
      end

    end
  end

  class PartialSetLookupTest < Test::Unit::TestCase
    context "A partial set" do
      subject { PartialSet.new }

      should "lookup a partial by name" do
        p = Partial.new(:poo) {}
        subject << p
        assert_equal p, subject.get(:poo)
        assert_equal p, subject.get('poo')
        assert_equal nil, subject.get(:ugh)
      end

    end
  end

end
