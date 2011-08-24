require "assert"
require "osheet/template_set"

module Osheet
  class TemplateSetTest < Assert::Context
    desc "Osheet::TemplateSet"
    before { @set = TemplateSet.new }
    subject { @set }

    should "be a PartialSet" do
      assert_kind_of PartialSet, subject
    end

    should "verify set objs are templates" do
      assert_raises ArgumentError do
        subject.send(:verify, {})
      end
      assert_nothing_raised do
        subject.send(:verify, Template.new(:row, :poo) {})
      end
    end

    should "key templates using an array of their element and name" do
      assert_equal ['row','poo'], subject.send(:key, :row, :poo)
    end

    should "key on templates objs" do
      assert_equal ['row', 'poo'], subject.send(:template_key, Template.new(:row, :poo) {})
    end

    should "init the key in the set when verifying" do
      key = subject.send(:verify, Template.new(:row, :poo) {})
      assert_equal ['row', 'poo'], key
      assert_equal({
        key.first => { key.last => nil }
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
      assert_kind_of Template, subject["row"]["poo"]
      assert subject["row"]["not_poo"]
      assert_kind_of Template, subject["row"]["not_poo"]
      assert subject["column"]
      assert_equal 2, subject["column"].keys.size
      assert subject["column"]["awesome"]
      assert_kind_of Template, subject["column"]["awesome"]
      assert subject["column"]["not_awesome"]
      assert_kind_of Template, subject["column"]["not_awesome"]
    end

    should "lookup a template by element, name" do
      t = Template.new(:row, :poo) {}
      subject << t
      assert_equal t, subject.get(:row, :poo)
      assert_equal t, subject.get('row', 'poo')

      assert_equal nil, subject.get(:row, :ugh)
      assert_equal nil, subject.get(:col, :ugh)
    end

  end

end
