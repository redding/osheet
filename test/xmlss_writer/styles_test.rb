require "assert"

require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriterStylesTest < Assert::Context
    before do
      @writer = XmlssWriter.new
      @workbook = Workbook.new(@writer)
    end
    subject { @writer }

    should "not have a style cache until its bound to an osheet workbook" do
      writer = XmlssWriter.new
      assert_nil writer.style_cache
      writer.bind(@workbook)
      assert_not_nil writer.style_cache
    end

  end

  class XmlssWriterStyleTests < XmlssWriterStylesTest
    desc "Xmlss style writer"
    before do
      @workbook.style('.font.size')    { @workbook.font 14 }
      @workbook.style('.font.weight')  { @workbook.font :bold }
      @workbook.style('.font.style')   { @workbook.font :italic }
      @workbook.style('.align.center') { @workbook.align :center }
    end

    should "build a style obj and add it to the writers styles" do
      xmlss_style = subject.style('awesome')
      assert_kind_of ::Xmlss::Style::Base, xmlss_style
      assert_equal '.awesome', xmlss_style.id
      assert_equal 1, subject.style_cache.size
      assert_equal xmlss_style, subject.style_cache[xmlss_style.id]
    end

    should "write style markup from many matching osheet styles" do
      xmlss_style = subject.style('font size weight style align center')
      assert_equal '.font.size.weight.style.align.center', xmlss_style.id
    end

  end

  class XmlssWriterAlignmentTests <  XmlssWriterStylesTest
    desc "Alignment style writer"
    before do
      [ :left, :center, :right,
        :top, :middle, :bottom,
        :wrap
      ].each do |s|
        @workbook.style(".align.#{s}") { @workbook.align s }
      end
      @workbook.style('.align.rotate') { @workbook.align 90 }
    end

    should "write style markup with no alignment settings if no alignment style match" do
      subject.style('align')
      assert_equal(
        "<Style ss:ID=\".align\"><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for horizontal alignment settings" do
      subject.style('align left')
      subject.style('align center')
      subject.style('align right')
      assert_equal(
        "<Style ss:ID=\".align.left\"><Alignment ss:Horizontal=\"Left\" /><NumberFormat /></Style><Style ss:ID=\".align.center\"><Alignment ss:Horizontal=\"Center\" /><NumberFormat /></Style><Style ss:ID=\".align.right\"><Alignment ss:Horizontal=\"Right\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for vertical alignment settings" do
      subject.style('align top')
      subject.style('align middle')
      subject.style('align bottom')
      assert_equal(
        "<Style ss:ID=\".align.top\"><Alignment ss:Vertical=\"Top\" /><NumberFormat /></Style><Style ss:ID=\".align.middle\"><Alignment ss:Vertical=\"Center\" /><NumberFormat /></Style><Style ss:ID=\".align.bottom\"><Alignment ss:Vertical=\"Bottom\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for text wrap settings" do
      subject.style('align wrap')
      assert_equal(
        "<Style ss:ID=\".align.wrap\"><Alignment ss:WrapText=\"1\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for text rotation settings" do
      subject.style('align rotate')
      assert_equal(
        "<Style ss:ID=\".align.rotate\"><Alignment ss:Rotate=\"90\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

  end

  class XmlssWriterFontTests < XmlssWriterStylesTest
    desc "Font style writer"
    before do
      [ :underline, :double_underline, :accounting_underline, :double_accounting_underline,
        :subscript, :superscript, :shadow, :strikethrough, :wrap,
        :bold, :italic
      ].each do |s|
        @workbook.style(".font.#{s}") { @workbook.font s }
      end
      @workbook.style('.font.size')  { @workbook.font 14 }
      @workbook.style('.font.color') { @workbook.font '#FF0000' }
      @workbook.style('.font.name')  { @workbook.font 'Verdana' }
    end

    should "write style markup with empty font settings if no match" do
      subject.style('font')
      assert_equal(
        "<Style ss:ID=\".font\"><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for font underline settings" do
      subject.style('font underline')
      subject.style('font double_underline')
      subject.style('font accounting_underline')
      subject.style('font double_accounting_underline')
      assert_equal(
       "<Style ss:ID=\".font.underline\"><Font ss:Underline=\"Single\" /><NumberFormat /></Style><Style ss:ID=\".font.double_underline\"><Font ss:Underline=\"Double\" /><NumberFormat /></Style><Style ss:ID=\".font.accounting_underline\"><Font ss:Underline=\"SingleAccounting\" /><NumberFormat /></Style><Style ss:ID=\".font.double_accounting_underline\"><Font ss:Underline=\"DoubleAccounting\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )

    end

    should "write style markup for font alignment settings" do
      subject.style('font subscript')
      subject.style('font superscript')
      assert_equal(
        "<Style ss:ID=\".font.subscript\"><Font ss:VerticalAlign=\"Subscript\" /><NumberFormat /></Style><Style ss:ID=\".font.superscript\"><Font ss:VerticalAlign=\"Superscript\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for font style settings" do
      subject.style('font bold')
      subject.style('font italic')
      subject.style('font strikethrough')
      subject.style('font shadow')
      assert_equal(
        "<Style ss:ID=\".font.bold\"><Font ss:Bold=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.italic\"><Font ss:Italic=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.strikethrough\"><Font ss:StrikeThrough=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.shadow\"><Font ss:Shadow=\"1\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for font size" do
      subject.style('font size')
      assert_equal(
        "<Style ss:ID=\".font.size\"><Font ss:Size=\"14\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for font color" do
      subject.style('font color')
      assert_equal(
        "<Style ss:ID=\".font.color\"><Font ss:Color=\"#FF0000\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for font name" do
      subject.style('font name')
      assert_equal(
        "<Style ss:ID=\".font.name\"><Font ss:FontName=\"Verdana\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

  end

  class XmlssWriterBgTests < XmlssWriterStylesTest
    desc "Bg writer"
    before do
      @workbook.style('.bg.color')         { @workbook.bg '#FF0000' }
      @workbook.style('.bg.pattern-only')  { @workbook.bg :solid }
      @workbook.style('.bg.pattern-color') { @workbook.bg :horz_stripe => '#0000FF' }
      @workbook.style('.bg.color-first')   { @workbook.bg '#00FF00', {:horz_stripe => '#0000FF'} }
      @workbook.style('.bg.pattern-first') { @workbook.bg({:horz_stripe => '#0000FF'}, '#00FF00') }
    end

    should "write style markup with empty bg settings when no match" do
      subject.style('bg')
      assert_equal(
        "<Style ss:ID=\".bg\"><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for bg color and auto set the pattern to solid" do
      subject.style('bg color')
      assert_equal(
        "<Style ss:ID=\".bg.color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"Solid\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for bg pattern settings" do
      subject.style('bg pattern-only')
      subject.style('bg pattern-only')
      subject.style('bg pattern-color')
      subject.style('bg pattern-color')
      assert_equal(
        "<Style ss:ID=\".bg.pattern-only\"><Interior ss:Pattern=\"Solid\" /><NumberFormat /></Style><Style ss:ID=\".bg.pattern-color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup setting pattern to solid when setting bg color" do
      subject.style('bg color')
      assert_equal(
        "<Style ss:ID=\".bg.color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"Solid\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup setting pattern to pattern setting when first setting bg color then pattern" do
      subject.style('bg color-first')
      assert_equal(
        "<Style ss:ID=\".bg.color-first\"><Interior ss:Color=\"#00FF00\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup setting pattern to pattern setting when first setting bg pattern then color" do
      subject.style('bg pattern-first')
      assert_equal(
        "<Style ss:ID=\".bg.pattern-first\"><Interior ss:Color=\"#00FF00\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

  end

  class XmlssWriterBorderTests < XmlssWriterStylesTest
    desc "Font border writer"
    before do
      ::Osheet::Style::BORDER_POSITIONS.each do |p|
        @workbook.style(".border.#{p}") { @workbook.send("border_#{p}", :thin) }
      end
      [:hairline, :thin, :medium, :thick].each do |w|
        @workbook.style(".border.#{w}") { @workbook.border_top w }
      end
      [:none, :continuous, :dash, :dot, :dash_dot, :dash_dot_dot].each do |s|
        @workbook.style(".border.#{s}") { @workbook.border_top s }
      end
      @workbook.style('.border.color')  { @workbook.border_top '#FF0000' }
      @workbook.style('.border.all')    { @workbook.border :thick, :dash, '#FF0000' }
    end

    should "write style markup with empty border settings when no match" do
      subject.style('border')
      assert_equal(
        "<Style ss:ID=\".border\"><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup with identical settings for all positions when using 'border'" do
      subject.style('border all')
      assert_equal(
        "<Style ss:ID=\".border.all\"><Borders><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Top\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Right\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Bottom\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Left\" ss:Weight=\"3\" /></Borders><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for border specific positions" do
      ::Osheet::Style::BORDER_POSITIONS.each do |p|
        subject.style("border #{p}")
      end
      assert_equal(
        "<Style ss:ID=\".border.top\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.right\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Right\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.bottom\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Bottom\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.left\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Left\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for border weight settings" do
      [:hairline, :thin, :medium, :thick].each do |w|
        subject.style("border #{w}")
      end
      assert_equal(
        "<Style ss:ID=\".border.hairline\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"0\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.thin\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.medium\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"2\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.thick\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"3\" /></Borders><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for border style settings" do
      [:none, :continuous, :dash, :dot, :dash_dot, :dash_dot_dot].each do |s|
        subject.style("border #{s}")
      end
      assert_equal(
        "<Style ss:ID=\".border.none\"><Borders><Border ss:LineStyle=\"None\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.continuous\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash\"><Borders><Border ss:LineStyle=\"Dash\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dot\"><Borders><Border ss:LineStyle=\"Dot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash_dot\"><Borders><Border ss:LineStyle=\"DashDot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash_dot_dot\"><Borders><Border ss:LineStyle=\"DashDotDot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

    should "write style markup for border color" do
      subject.style('border color')
      assert_equal(
        "<Style ss:ID=\".border.color\"><Borders><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xmlss_style_markup(subject)
      )
    end

  end

  class XmlssWriterNumberFormatTests < XmlssWriterStylesTest
    desc "Xmlss style number format writer"

    should "write style markup with formatting" do
      subject.style('', Osheet::Format.new(:text))
      subject.style('', Osheet::Format.new(:datetime, 'mm/dd/yy'))
      assert_equal(
        "<Style ss:ID=\"..text\"><NumberFormat ss:Format=\"@\" /></Style><Style ss:ID=\"..datetime_mm/dd/yy\"><NumberFormat ss:Format=\"mm/dd/yy\" /></Style>",
        xmlss_style_markup(subject)
      )
    end

  end

end
