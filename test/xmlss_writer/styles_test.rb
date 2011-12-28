require "assert"

require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::StylesTest < Assert::Context
    before do
      @writer = XmlssWriter::Base.new
      @xworkbook = ::Xmlss::Workbook.new
    end
    subject { @writer }

  end

  class XmlssWriter::StyleTests < XmlssWriter::StylesTest
    desc "Xmlss style writer"
    before do
      subject.oworkbook = Workbook.new {
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
      assert_equal nil, subject.send(:style, @xworkbook, '')
    end

    should "build a style obj and add it to the writers styles" do
      xmlss_style = subject.send(:style, @xworkbook, 'awesome')
      assert_kind_of ::Xmlss::Style::Base, xmlss_style
      assert_equal '.awesome', xmlss_style.id
      assert_equal 1, subject.used_xstyles.size
      assert_equal xmlss_style, subject.used_xstyles.first
    end

    should "write style markup from many matching osheet styles" do
      xmlss_style = subject.send(:style, @xworkbook, 'font size weight style align center')
      assert_equal '.font.size.weight.style.align.center', xmlss_style.id

      assert_equal(
        "<Style ss:ID=\".font.size.weight.style.align.center\"><Alignment ss:Horizontal=\"Center\" /><Font ss:Bold=\"1\" ss:Italic=\"1\" ss:Size=\"14\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "provide style ids" do
      assert_equal '', subject.send(:style_id, @xworkbook, '')
      assert_equal '.awesome', subject.send(:style_id, @xworkbook, 'awesome')
      assert_equal '..number_none_0_nocomma_black', subject.send(:style_id, @xworkbook, '', Osheet::Format.new(:number))
      assert_equal 2, subject.used_xstyles.size
    end

  end

  class XmlssWriter::AlignmentTests <  XmlssWriter::StylesTest
    desc "Alignment style writer"
    before do
      subject.oworkbook = Workbook.new {
        [ :left, :center, :right,
          :top, :middle, :bottom,
          :wrap
        ].each do |s|
          style(".align.#{s}") { align s }
        end
        style('.align.rotate') { align 90 }
      }
    end

    should "write style markup with no alignment settings if no alignment style match" do
      subject.send(:style, @xworkbook, 'align')
      assert_equal(
        "<Style ss:ID=\".align\"><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for horizontal alignment settings" do
      subject.send(:style, @xworkbook, 'align left')
      subject.send(:style, @xworkbook, 'align center')
      subject.send(:style, @xworkbook, 'align right')
      assert_equal(
        "<Style ss:ID=\".align.left\"><Alignment ss:Horizontal=\"Left\" /><NumberFormat /></Style><Style ss:ID=\".align.center\"><Alignment ss:Horizontal=\"Center\" /><NumberFormat /></Style><Style ss:ID=\".align.right\"><Alignment ss:Horizontal=\"Right\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for vertical alignment settings" do
      subject.send(:style, @xworkbook, 'align top')
      subject.send(:style, @xworkbook, 'align middle')
      subject.send(:style, @xworkbook, 'align bottom')
      assert_equal(
        "<Style ss:ID=\".align.top\"><Alignment ss:Vertical=\"Top\" /><NumberFormat /></Style><Style ss:ID=\".align.middle\"><Alignment ss:Vertical=\"Center\" /><NumberFormat /></Style><Style ss:ID=\".align.bottom\"><Alignment ss:Vertical=\"Bottom\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for text wrap settings" do
      subject.send(:style, @xworkbook, 'align wrap')
      assert_equal(
        "<Style ss:ID=\".align.wrap\"><Alignment ss:WrapText=\"1\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for text rotation settings" do
      subject.send(:style, @xworkbook, 'align rotate')
      assert_equal(
        "<Style ss:ID=\".align.rotate\"><Alignment ss:Rotate=\"90\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::FontTests < XmlssWriter::StylesTest
    desc "Font style writer"
    before do
      subject.oworkbook = Workbook.new {
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

    should "write style markup with empty font settings if no match" do
      subject.send(:style, @xworkbook, 'font')
      assert_equal(
        "<Style ss:ID=\".font\"><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for font underline settings" do
      subject.send(:style, @xworkbook, 'font underline')
      subject.send(:style, @xworkbook, 'font double_underline')
      subject.send(:style, @xworkbook, 'font accounting_underline')
      subject.send(:style, @xworkbook, 'font double_accounting_underline')
      assert_equal(
       "<Style ss:ID=\".font.underline\"><Font ss:Underline=\"Single\" /><NumberFormat /></Style><Style ss:ID=\".font.double_underline\"><Font ss:Underline=\"Double\" /><NumberFormat /></Style><Style ss:ID=\".font.accounting_underline\"><Font ss:Underline=\"SingleAccounting\" /><NumberFormat /></Style><Style ss:ID=\".font.double_accounting_underline\"><Font ss:Underline=\"DoubleAccounting\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )

    end

    should "write style markup for font alignment settings" do
      subject.send(:style, @xworkbook, 'font subscript')
      subject.send(:style, @xworkbook, 'font superscript')
      assert_equal(
        "<Style ss:ID=\".font.subscript\"><Font ss:VerticalAlign=\"Subscript\" /><NumberFormat /></Style><Style ss:ID=\".font.superscript\"><Font ss:VerticalAlign=\"Superscript\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for font style settings" do
      subject.send(:style, @xworkbook, 'font bold')
      subject.send(:style, @xworkbook, 'font italic')
      subject.send(:style, @xworkbook, 'font strikethrough')
      subject.send(:style, @xworkbook, 'font shadow')
      assert_equal(
        "<Style ss:ID=\".font.bold\"><Font ss:Bold=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.italic\"><Font ss:Italic=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.strikethrough\"><Font ss:StrikeThrough=\"1\" /><NumberFormat /></Style><Style ss:ID=\".font.shadow\"><Font ss:Shadow=\"1\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for font size" do
      subject.send(:style, @xworkbook, 'font size')
      assert_equal(
        "<Style ss:ID=\".font.size\"><Font ss:Size=\"14\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for font color" do
      subject.send(:style, @xworkbook, 'font color')
      assert_equal(
        "<Style ss:ID=\".font.color\"><Font ss:Color=\"#FF0000\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for font name" do
      subject.send(:style, @xworkbook, 'font name')
      assert_equal(
        "<Style ss:ID=\".font.name\"><Font ss:FontName=\"Verdana\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::BgTests < XmlssWriter::StylesTest
    desc "Bg writer"
    before do
      subject.oworkbook = Workbook.new {
        style('.bg.color') { bg '#FF0000' }
        style('.bg.pattern-only') { bg :solid }
        style('.bg.pattern-color') { bg :horz_stripe => '#0000FF' }
        style('.bg.color-first') { bg '#00FF00', {:horz_stripe => '#0000FF'} }
        style('.bg.pattern-first') { bg({:horz_stripe => '#0000FF'}, '#00FF00') }
      }
    end

    should "write style markup with empty bg settings when no match" do
      subject.send(:style, @xworkbook, 'bg')
      # assert_equal nil, .interior
      assert_equal(
        "<Style ss:ID=\".bg\"><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for bg color and auto set the pattern to solid" do
      subject.send(:style, @xworkbook, 'bg color')
      # assert_equal '#FF0000', .interior.color
      assert_equal(
        "<Style ss:ID=\".bg.color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"Solid\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for bg pattern settings" do
      subject.send(:style, @xworkbook, 'bg pattern-only')
      subject.send(:style, @xworkbook, 'bg pattern-only')
      subject.send(:style, @xworkbook, 'bg pattern-color')
      subject.send(:style, @xworkbook, 'bg pattern-color')
      assert_equal(
        "<Style ss:ID=\".bg.pattern-only\"><Interior ss:Pattern=\"Solid\" /><NumberFormat /></Style><Style ss:ID=\".bg.pattern-color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup setting pattern to solid when setting bg color" do
      subject.send(:style, @xworkbook, 'bg color')
      assert_equal(
        "<Style ss:ID=\".bg.color\"><Interior ss:Color=\"#FF0000\" ss:Pattern=\"Solid\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup setting pattern to pattern setting when first setting bg color then pattern" do
      subject.send(:style, @xworkbook, 'bg color-first')
      assert_equal(
        "<Style ss:ID=\".bg.color-first\"><Interior ss:Color=\"#00FF00\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup setting pattern to pattern setting when first setting bg pattern then color" do
      subject.send(:style, @xworkbook, 'bg pattern-first')
      assert_equal(
        "<Style ss:ID=\".bg.pattern-first\"><Interior ss:Color=\"#00FF00\" ss:Pattern=\"HorzStripe\" ss:PatternColor=\"#0000FF\" /><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::BorderTests < XmlssWriter::StylesTest
    desc "Font border writer"
    before do
      subject.oworkbook = Workbook.new {
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

    should "write style markup with empty border settings when no match" do
      subject.send(:style, @xworkbook, 'border')
      assert_equal(
        "<Style ss:ID=\".border\"><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup with identical settings for all positions when using 'border'" do
      subject.send(:style, @xworkbook, 'border all')
      assert_equal(
        "<Style ss:ID=\".border.all\"><Borders><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Top\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Right\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Bottom\" ss:Weight=\"3\" /><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Dash\" ss:Position=\"Left\" ss:Weight=\"3\" /></Borders><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for border specific positions" do
      ::Osheet::Style::BORDER_POSITIONS.each do |p|
        subject.send(:style, @xworkbook, "border #{p}")
      end
      assert_equal(
        "<Style ss:ID=\".border.top\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.right\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Right\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.bottom\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Bottom\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.left\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Left\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for border weight settings" do
      [:hairline, :thin, :medium, :thick].each do |w|
        subject.send(:style, @xworkbook, "border #{w}")
      end
      assert_equal(
        "<Style ss:ID=\".border.hairline\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"0\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.thin\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.medium\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"2\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.thick\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"3\" /></Borders><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for border style settings" do
      [:none, :continuous, :dash, :dot, :dash_dot, :dash_dot_dot].each do |s|
        subject.send(:style, @xworkbook, "border #{s}")
      end
      assert_equal(
        "<Style ss:ID=\".border.none\"><Borders><Border ss:LineStyle=\"None\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.continuous\"><Borders><Border ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash\"><Borders><Border ss:LineStyle=\"Dash\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dot\"><Borders><Border ss:LineStyle=\"Dot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash_dot\"><Borders><Border ss:LineStyle=\"DashDot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style><Style ss:ID=\".border.dash_dot_dot\"><Borders><Border ss:LineStyle=\"DashDotDot\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

    should "write style markup for border color" do
      subject.send(:style, @xworkbook, 'border color')
      assert_equal(
        "<Style ss:ID=\".border.color\"><Borders><Border ss:Color=\"#FF0000\" ss:LineStyle=\"Continuous\" ss:Position=\"Top\" ss:Weight=\"1\" /></Borders><NumberFormat /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

  end

  class XmlssWriter::NumberFormatTests < XmlssWriter::StylesTest
    desc "Xmlss style number format writer"
    before do
      subject.oworkbook = Workbook.new {}
    end

    should "write style markup with formatting" do
      subject.send(:style, @xworkbook, '', Osheet::Format.new(:text))
      subject.send(:style, @xworkbook, '', Osheet::Format.new(:datetime, 'mm/dd/yy'))
      assert_equal(
        "<Style ss:ID=\"..text\"><NumberFormat ss:Format=\"@\" /></Style><Style ss:ID=\"..datetime_mm/dd/yy\"><NumberFormat ss:Format=\"mm/dd/yy\" /></Style>",
        xstyle_markup(@xworkbook)
      )
    end

  end

end
