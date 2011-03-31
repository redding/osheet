require "test/helper"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::Style < Test::Unit::TestCase
    context("Xmlss style writer") do

      subject { XmlssWriter::Base.new }

      should "build a style obj when writing styles" do
        assert_kind_of ::Xmlss::Style::Base, subject.send(:style, '')
      end

    end
  end

  class XmlssWriter::Alignment < Test::Unit::TestCase
    context("Alignment style writer") do

      subject { XmlssWriter::Base.new }
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
  end

  class XmlssWriter::Font < Test::Unit::TestCase
    context("Font style writer") do

      subject { XmlssWriter::Base.new }
      before do
        subject.workbook = Workbook.new {
          [
            :underline, :double_underline,
            :subscript, :superscript,
            :bold, :italic, :strikethrough,
            :wrap
          ].each do |s|
            style(".font.#{s}") { font s }
          end
          style('.font.size') { font 14 }
          style('.font.color') { font '#FF0000' }
        }
      end

      should "build a style obj with empty font settings by default" do
        assert_equal nil, subject.send(:style, 'font').font
      end

      should "build style objs for font underline settings" do
        assert_equal ::Xmlss::Style::Font.underline(:single), subject.send(:style, 'font underline').font.underline
        assert_equal ::Xmlss::Style::Font.underline(:double), subject.send(:style, 'font double_underline').font.underline
      end

      should "build style objs for font alignment settings" do
        assert_equal ::Xmlss::Style::Font.alignment(:subscript), subject.send(:style, 'font subscript').font.alignment
        assert_equal ::Xmlss::Style::Font.alignment(:superscript), subject.send(:style, 'font superscript').font.alignment
      end

      should "build style objs for font style settings" do
        assert_equal true, subject.send(:style, 'font bold').font.bold?
        assert_equal true, subject.send(:style, 'font italic').font.italic?
        assert_equal true, subject.send(:style, 'font strikethrough').font.strike_through?
      end

      should "build style objs for font size" do
        assert_equal 14, subject.send(:style, 'font size').font.size
      end

      should "build style objs for font color" do
        assert_equal '#FF0000', subject.send(:style, 'font color').font.color
      end

    end
  end

  class XmlssWriter::Bg < Test::Unit::TestCase
    context("Font bg writer") do

      subject { XmlssWriter::Base.new }
      before do
        subject.workbook = Workbook.new {
          style('.bg.color') { bg '#FF0000' }
          style('.bg.pattern-only') { bg :solid }
          style('.bg.pattern-color') { bg :horz_stripe => '#0000FF' }
        }
      end

      should "build a style obj with empty bg settings by default" do
        assert_equal nil, subject.send(:style, 'bg').interior
      end

      should "build style objs for bg color" do
        assert_equal '#FF0000', subject.send(:style, 'bg color').interior.color
      end

      should "build style objs for bg pattern settings" do
        assert_equal ::Xmlss::Style::Interior.pattern(:solid), subject.send(:style, 'bg pattern-only').interior.pattern
        assert_equal nil, subject.send(:style, 'bg pattern-only').interior.pattern_color
        assert_equal ::Xmlss::Style::Interior.pattern(:horz_stripe), subject.send(:style, 'bg pattern-color').interior.pattern
        assert_equal '#0000FF', subject.send(:style, 'bg pattern-color').interior.pattern_color
      end

    end
  end

  class XmlssWriter::Border < Test::Unit::TestCase
    context("Font border writer") do

      subject { XmlssWriter::Base.new }
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
  end

  class XmlssWriter::NumberFormat < Test::Unit::TestCase
    context("Xmlss style number format writer") do

      subject { XmlssWriter::Base.new }

      should "build a style obj with formatting" do
        assert_equal '@', subject.send(:style, '', '@').number_format.format
        assert_equal 'mm/dd/yy', subject.send(:style, '', 'mm/dd/yy').number_format.format
      end

    end
  end


end
