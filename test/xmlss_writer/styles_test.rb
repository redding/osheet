require "test/helper"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::StylesTest < Assert::Context
    before do
      @writer = XmlssWriter::Base.new
    end
    subject { @writer }

  end

  class XmlssWriter::Style < XmlssWriter::StylesTest
    desc "Xmlss style writer"
    before do
      subject.workbook = Workbook.new {
        style('.font.size') { font 14 }
        style('.font.weight') { font :bold }
        style('.font.style') { font :italic }
        style('.align.center') { align :center }
      }
    end

    should "key styles based off class str and format" do
      assert_equal '', subject.send(:style_key, '', nil)
      assert_equal '.awesome', subject.send(:style_key, 'awesome', nil)
      assert_equal '.awesome.thing', subject.send(:style_key, 'awesome thing', nil)
      assert_equal '.awesome..something', subject.send(:style_key, 'awesome', 'something')
      assert_equal '..something', subject.send(:style_key, '', 'something')
    end

    should "not build a style obj when writing styles with no class str or format" do
      assert_equal nil, subject.send(:style, '')
    end

    should "build a style obj and add it to the writers styles" do
      xmlss_style = subject.send(:style, 'awesome')
      assert_kind_of ::Xmlss::Style::Base, xmlss_style
      assert_equal '.awesome', xmlss_style.id
      assert_equal 1, subject.styles.size
      assert_equal xmlss_style, subject.styles.first
    end

    should "build a style obj from many matching osheet styles" do
      xmlss_style = subject.send(:style, 'font size weight style align center')
      assert_equal 14, xmlss_style.font.size
      assert_equal true, xmlss_style.font.bold?
      assert_equal true, xmlss_style.font.italic?
    end

    should "provide style ids" do
      assert_equal '', subject.send(:style_id, '')
      assert_equal '.awesome', subject.send(:style_id, 'awesome')
      assert_equal '..number_none_0_nocomma_black', subject.send(:style_id, '', Osheet::Format.new(:number))
      assert_equal 2, subject.styles.size
    end

  end

  class XmlssWriter::Alignment <  XmlssWriter::StylesTest
    desc "Alignment style writer"
    before do
      subject.workbook = Workbook.new {
        [
          :left, :center, :right,
          :top, :middle, :bottom,
          :wrap
        ].each do |s|
          style(".align.#{s}") { align s }
        end
        style('.align.rotate') { align 90 }
      }
    end

    should "build a style obj with empty alignment settings by default" do
      assert_equal nil, subject.send(:style, 'align').alignment
    end

    should "build style objs for horizontal alignment settings" do
      assert_equal ::Xmlss::Style::Alignment.horizontal(:left), subject.send(:style, 'align left').alignment.horizontal
      assert_equal ::Xmlss::Style::Alignment.horizontal(:center), subject.send(:style, 'align center').alignment.horizontal
      assert_equal ::Xmlss::Style::Alignment.horizontal(:right), subject.send(:style, 'align right').alignment.horizontal
    end

    should "build style objs for vertical alignment settings" do
      assert_equal ::Xmlss::Style::Alignment.vertical(:top), subject.send(:style, 'align top').alignment.vertical
      assert_equal ::Xmlss::Style::Alignment.vertical(:center), subject.send(:style, 'align middle').alignment.vertical
      assert_equal ::Xmlss::Style::Alignment.vertical(:bottom), subject.send(:style, 'align bottom').alignment.vertical
    end

    should "build style objs for text wrap settings" do
      assert_equal true, subject.send(:style, 'align wrap').alignment.wrap_text?
    end

    should "build style objs for text rotation settings" do
      assert_equal 90, subject.send(:style, 'align rotate').alignment.rotate
    end

  end

  class XmlssWriter::Font < XmlssWriter::StylesTest
    desc "Font style writer"
    before do
      subject.workbook = Workbook.new {
        [ :underline, :double_underline, :accounting_underline, :double_accounting_underline,
          :subscript, :superscript, :shadow, :strikethrough, :wrap,
          :bold, :italic
        ].each do |s|
          style(".font.#{s}") { font s }
        end
        style('.font.size') { font 14 }
        style('.font.color') { font '#FF0000' }
        style('.font.name') { font 'Verdana' }
      }
    end

    should "build a style obj with empty font settings by default" do
      assert_equal nil, subject.send(:style, 'font').font
    end

    should "build style objs for font underline settings" do
      assert_equal ::Xmlss::Style::Font.underline(:single), subject.send(:style, 'font underline').font.underline
      assert_equal ::Xmlss::Style::Font.underline(:double), subject.send(:style, 'font double_underline').font.underline
      assert_equal ::Xmlss::Style::Font.underline(:single_accounting), subject.send(:style, 'font accounting_underline').font.underline
      assert_equal ::Xmlss::Style::Font.underline(:double_accounting), subject.send(:style, 'font double_accounting_underline').font.underline
    end

    should "build style objs for font alignment settings" do
      assert_equal ::Xmlss::Style::Font.alignment(:subscript), subject.send(:style, 'font subscript').font.alignment
      assert_equal ::Xmlss::Style::Font.alignment(:superscript), subject.send(:style, 'font superscript').font.alignment
    end

    should "build style objs for font style settings" do
      assert_equal true, subject.send(:style, 'font bold').font.bold?
      assert_equal true, subject.send(:style, 'font italic').font.italic?
      assert_equal true, subject.send(:style, 'font strikethrough').font.strike_through?
      assert_equal true, subject.send(:style, 'font shadow').font.shadow?
    end

    should "build style objs for font size" do
      assert_equal 14, subject.send(:style, 'font size').font.size
    end

    should "build style objs for font color" do
      assert_equal '#FF0000', subject.send(:style, 'font color').font.color
    end

    should "build style objs for font name" do
      assert_equal 'Verdana', subject.send(:style, 'font name').font.name
    end

  end

  class XmlssWriter::Bg < XmlssWriter::StylesTest
    desc "Bg writer"
    before do
      subject.workbook = Workbook.new {
        style('.bg.color') { bg '#FF0000' }
        style('.bg.pattern-only') { bg :solid }
        style('.bg.pattern-color') { bg :horz_stripe => '#0000FF' }
        style('.bg.color-first') { bg '#00FF00', {:horz_stripe => '#0000FF'} }
        style('.bg.pattern-first') { bg({:horz_stripe => '#0000FF'}, '#00FF00') }
      }
    end

    should "build a style obj with empty bg settings by default" do
      assert_equal nil, subject.send(:style, 'bg').interior
    end

    should "build style objs for bg color and auto set the pattern to solid" do
      assert_equal '#FF0000', subject.send(:style, 'bg color').interior.color
    end

    should "build style objs for bg pattern settings" do
      assert_equal ::Xmlss::Style::Interior.pattern(:solid), subject.send(:style, 'bg pattern-only').interior.pattern
      assert_equal nil, subject.send(:style, 'bg pattern-only').interior.pattern_color
      assert_equal ::Xmlss::Style::Interior.pattern(:horz_stripe), subject.send(:style, 'bg pattern-color').interior.pattern
      assert_equal '#0000FF', subject.send(:style, 'bg pattern-color').interior.pattern_color
    end

    should "set pattern to solid when setting bg color" do
      assert_equal ::Xmlss::Style::Interior.pattern(:solid), subject.send(:style, 'bg color').interior.pattern
    end

    should "set pattern to pattern setting when first setting bg color then pattern" do
      assert_equal ::Xmlss::Style::Interior.pattern(:horz_stripe), subject.send(:style, 'bg color-first').interior.pattern
    end

    should "set pattern to pattern setting when first setting bg pattern then color" do
      assert_equal ::Xmlss::Style::Interior.pattern(:horz_stripe), subject.send(:style, 'bg pattern-first').interior.pattern
    end

  end

  class XmlssWriter::Border < XmlssWriter::StylesTest
    desc "Font border writer"
    before do
      subject.workbook = Workbook.new {
        ::Osheet::Style::BORDER_POSITIONS.each do |p|
          style(".border.#{p}") { send("border_#{p}", :thin) }
        end
        [:hairline, :thin, :medium, :thick].each do |w|
          style(".border.#{w}") { border_top w }
        end
        [:none, :continuous, :dash, :dot, :dash_dot, :dash_dot_dot].each do |s|
          style(".border.#{s}") { border_top s }
        end
        style('.border.color') { border_top '#FF0000' }
        style('.border.all') { border :thick, :dash, '#FF0000' }
      }
    end

    should "build a style obj with empty border settings by default" do
      style = subject.send(:style, 'border')
      assert_kind_of ::Xmlss::ItemSet, style.borders
      assert_equal [], style.borders
    end

    should "build style objs with identical settings for all positions when using 'border'" do
      style = subject.send(:style, 'border all')
      assert_equal 4, style.borders.size
      assert_equal 1, style.borders.collect{|p| p.weight}.uniq.size
      assert_equal 1, style.borders.collect{|p| p.line_style}.uniq.size
      assert_equal 1, style.borders.collect{|p| p.color}.uniq.size
    end

    should "build style objs for border specific positions" do
      ::Osheet::Style::BORDER_POSITIONS.each do |p|
        assert_equal ::Xmlss::Style::Border.position(p), subject.send(:style, "border #{p}").borders.first.position
      end
    end

    should "build style objs for border weight settings" do
      [:hairline, :thin, :medium, :thick].each do |w|
        assert_equal ::Xmlss::Style::Border.weight(w), subject.send(:style, "border #{w}").borders.first.weight
      end
    end

    should "build style objs for border style settings" do
      [:none, :continuous, :dash, :dot, :dash_dot, :dash_dot_dot].each do |s|
        assert_equal ::Xmlss::Style::Border.line_style(s), subject.send(:style, "border #{s}").borders.first.line_style
      end
    end

    should "build style objs for border color" do
      assert_equal '#FF0000', subject.send(:style, 'border color').borders.first.color
    end

  end

  class XmlssWriter::NumberFormat < XmlssWriter::StylesTest
    desc "Xmlss style number format writer"

    should "build a style obj with formatting" do
      assert_equal '@', subject.send(:style, '', Osheet::Format.new(:text)).number_format.format
      assert_equal 'mm/dd/yy', subject.send(:style, '', Osheet::Format.new(:datetime, 'mm/dd/yy')).number_format.format
    end

  end

end
