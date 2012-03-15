require "assert"

require 'osheet/xmlss_writer/style_cache'

module Osheet

  class XmlssWriterStyleCacheTests < Assert::Context
    desc "the style cache"
    before do
      @workbook = Workbook.new
      @workbook.style('.align.center') { @workbook.align  :center }
      @workbook.style('.font.size')    { @workbook.font   14      }
      @workbook.style('.font.weight')  { @workbook.font   :bold   }
      @workbook.style('.font.style')   { @workbook.font   :italic }
      @workbook.style('.bg.color')     { @workbook.bg     '#FF0000' }
      @workbook.style('.border.color') { @workbook.border '#FF0000', :thin }
      @xmlss_workbook = Xmlss::Workbook.new(Xmlss::Writer.new)

      @cache = XmlssWriter::StyleCache.new(@workbook, @xmlss_workbook)
    end
    subject { @cache }

    should have_reader :styles
    should have_instance_method :get, :keys, :empty?, :size, :[]

    should "have no cached styles by default" do
      assert_empty subject
    end

    should "key based off class value and format key" do
      assert_equal '',                    subject.send(:key, '', nil)
      assert_equal '.awesome',            subject.send(:key, 'awesome', nil)
      assert_equal '.awesome.thing',      subject.send(:key, 'awesome thing', nil)
      assert_equal '.awesome..something', subject.send(:key, 'awesome', 'something')
      assert_equal '..something',         subject.send(:key, '', 'something')
    end

    should "return nil if trying to get the style for an empty class and general format" do
      assert_not_nil subject.get('font', Osheet::Format.new(:general))
      assert_nil     subject.get('',     Osheet::Format.new(:general))
    end

    should "build and cache styles if not already cached" do
      assert_equal 0, subject.size
      subject.get('font', Osheet::Format.new(:currency))
      assert_equal 1, subject.size
    end

    should "return cached style if requesting an already cached style" do
      assert_equal 0, subject.size
      subject.get('font', Osheet::Format.new(:currency))
      subject.get('font', Osheet::Format.new(:currency))
      assert_equal 1, subject.size
    end

    should "build styles with ids matching the cache key" do
      key = subject.send(:key, 'font', Osheet::Format.new(:currency).key)
      assert_equal key, subject.get('font', Osheet::Format.new(:currency)).id
    end

  end



end
