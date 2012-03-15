require "assert"

require 'osheet/workbook_element'

module Osheet


  class WorkbookElementTests < Assert::Context
    desc "a WorkbookElement object"
    before do
      @wd = WorkbookElement.new
    end
    subject { @wd }

    should have_reader :title
    should have_readers :templates, :partials, :styles, :worksheets
    should have_instance_methods :template, :partial, :style, :worksheet

    should "set it's defaults" do
      assert_nil subject.title
      assert_equal WorkbookElement::TemplateSet.new,  subject.templates
      assert_equal WorkbookElement::PartialSet.new,   subject.partials
      assert_equal WorkbookElement::StyleSet.new,     subject.styles
      assert_equal WorkbookElement::WorksheetSet.new, subject.worksheets
    end

  end



  class PartialSetTests < Assert::Context
    desc "a PartialSet"
    before { @ps = WorkbookElement::PartialSet.new }
    subject { @ps }

    should "be a Hash" do
      assert_kind_of ::Hash, subject
    end

    should have_instance_method :<<
    should have_reader :get

    should "verify set objs are partials" do
      assert_raises ArgumentError do
        subject.send(:verify, {})
      end
      assert_nothing_raised do
        subject.send(:verify, Partial.new(:poo) {})
      end
    end

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

    should "lookup a partial by name" do
      p = Partial.new(:poo) {}
      subject << p
      assert_equal p, subject.get(:poo)
      assert_equal p, subject.get('poo')
      assert_equal nil, subject.get(:ugh)
    end

  end



  class TemplateSetTests < Assert::Context
    desc "a TemplateSet"
    before { @set = WorkbookElement::TemplateSet.new }
    subject { @set }

    should "be a PartialSet" do
      assert_kind_of WorkbookElement::PartialSet, subject
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



  class StyleSetTests < Assert::Context
    desc "a StyleSet"
    before { @set = WorkbookElement::StyleSet.new }
    subject { @set }

    should "be an Array" do
      assert_kind_of ::Array, subject
    end

    should have_reader :for

    should "verify Style objs" do
      assert_raises ArgumentError do
        subject.send(:verify, {})
      end
      assert_nothing_raised do
        subject.send(:verify, Style.new('.awesome') {})
      end
    end

    should "be able to lookup styles by class" do
      subject << (a = Style.new('.awesome') {})
      subject << (at = Style.new('.awesome.thing') {})
      subject << (b = Style.new('.boring') {})
      subject << (bt = Style.new('.boring.thing') {})
      subject << (a_b = Style.new('.awesome', '.boring') {})
      subject << (t = Style.new('.thing') {})
      subject << (s = Style.new('.stupid') {})

      { 'awesome' => [a, a_b],
        'boring' => [b, a_b],
        'thing' => [t],
        'awesome thing' => [a, at, a_b, t],
        'thing awesome' => [a, at, a_b, t],
        'other' => []
      }.each do |style_class, styles_set|
        assert_equal styles_set, subject.for(style_class)
      end
    end

    should "return itself if calling for w/ no args" do
      assert_equal subject, subject.for
    end

  end



  class WorksheetSetTests < Assert::Context
    desc "a WorksheetSet"
    before { @set = WorkbookElement::WorksheetSet.new }
    subject { @set }

    should "be an Array" do
      assert_kind_of ::Array, subject
    end

    should "verify Worksheet objs" do
      assert_raises ArgumentError do
        subject.send(:verify, {})
      end
      assert_nothing_raised do
        subject.send(:verify, Worksheet.new {})
      end
    end

  end


end
