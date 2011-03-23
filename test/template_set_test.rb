require "test/helper"
require "osheet/template_set"

module Osheet
  class TemplateSetTest < Test::Unit::TestCase

    context "Osheet::TemplateSet" do
      subject { TemplateSet.new }

      should "be a Hash" do
        assert_kind_of ::Hash, subject
      end

      should_have_instance_method :<<
      should_have_reader :templates

      should "key templates using their element and name" do
        assert_equal [:row, :poo], subject.send(:key, :row, :poo)
        assert_equal [:row, :row], subject.send(:key, :row, :row)
        assert_equal ['row', 'poo'], subject.send(:template_key, Template.new(:row, :poo) {})
      end

      should "verify Template objs" do
        assert_raises ArgumentError do
          subject.send(:verify, {})
        end
        assert_nothing_raised do
          subject.send(:verify, Template.new(:row, :poo) {})
        end
      end

      should "init the key when verify templates" do
        key = subject.send(:verify, Template.new(:row, :poo) {})
        assert_equal ['row', 'poo'], key
        assert_equal({
          key.first => { key.last => [] }
        }, subject)
      end

      should "push templates onto the set" do
        assert_nothing_raised do
          subject << Template.new(:row, :poo) {}
          subject << Template.new(:row, :not_poo) {}
          subject << Template.new(:column, :awesome) {}
          subject << Template.new(:column, :not_awesome) {}
        end

        assert_equal 2, subject.keys.size
        assert subject["row"]
        assert_equal 2, subject["row"].keys.size
        assert subject["row"]["poo"]
        assert_kind_of ::Array, subject["row"]["poo"]
        assert_equal 1, subject["row"]["poo"].size
        assert_kind_of Template, subject["row"]["poo"].first
        assert subject["row"]["not_poo"]
        assert_kind_of ::Array, subject["row"]["not_poo"]
        assert_equal 1, subject["row"]["not_poo"].size
        assert_kind_of Template, subject["row"]["not_poo"].first
        assert subject["column"]
        assert_equal 2, subject["column"].keys.size
        assert subject["column"]["awesome"]
        assert_kind_of ::Array, subject["column"]["awesome"]
        assert_equal 1, subject["column"]["awesome"].size
        assert_kind_of Template, subject["column"]["awesome"].first
        assert subject["column"]["not_awesome"]
        assert_kind_of ::Array, subject["column"]["not_awesome"]
        assert_equal 1, subject["column"]["not_awesome"].size
        assert_kind_of Template, subject["column"]["not_awesome"].first
      end

      should "be able to lookup a template by element, name" do
        t = Template.new(:row, :poo) {}
        subject << t
        assert_equal [t], subject.templates(:row, :poo)
        assert_equal [t], subject.templates('row', 'poo')
      end

    end

  end
end
