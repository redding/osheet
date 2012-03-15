require "assert"

require 'osheet/xmlss_writer/style_settings'

module Osheet

  class XmlssWriterStyleSettingsTests < Assert::Context
    desc "the style writer when building"
    before do
      @settings = XmlssWriter::StyleSettings.new([])
      @workbook = Workbook.new
      @workbook.style('.align.center') { @workbook.align  :center }
      @workbook.style('.font.size')    { @workbook.font   14      }
      @workbook.style('.font.weight')  { @workbook.font   :bold   }
      @workbook.style('.font.style')   { @workbook.font   :italic }
      @workbook.style('.bg.color')     { @workbook.bg     '#FF0000' }
      @workbook.style('.border.color') { @workbook.border '#FF0000', :thin }
    end
    subject { @settings }

    should have_reader :styles, :value
    should have_instance_method :setting, :[]

    should "be empty if no styles given" do
      assert_equal({}, subject.value)
    end

    should "conditionally run a block if the setting exists and is not empty" do
      settings = XmlssWriter::StyleSettings.new([@workbook.styles.first])
      @something = ''

      settings.setting(:font) { @something = 'i should be empty' }
      assert_empty @something

      settings.setting(:align) { @something = 'i should not be empty' }
      assert_not_empty @something
    end

  end



  class XmlssWriterAlignmentSettingsTests < XmlssWriterStyleSettingsTests
    desc "align settings"

    should "translate horizontal directives" do
      assert_equal({:horizontal => :left},   subject.send(:align_settings, [:left]))
      assert_equal({:horizontal => :center}, subject.send(:align_settings, [:center]))
      assert_equal({:horizontal => :right},  subject.send(:align_settings, [:right]))
    end

    should "translate vertical directives" do
      assert_equal({:vertical => :top},    subject.send(:align_settings, [:top]))
      assert_equal({:vertical => :center}, subject.send(:align_settings, [:middle]))
      assert_equal({:vertical => :bottom}, subject.send(:align_settings, [:bottom]))
    end

    should "translate wrap text and rotate directives" do
      assert_equal({:wrap_text => true}, subject.send(:align_settings, [:wrap]))
      assert_equal({:rotate => 90},       subject.send(:align_settings, [90]))
    end

  end



  class XmlssWriterFontSettingsTests < XmlssWriterStyleSettingsTests
    desc "font settings"

    should "translate size, color and name directives" do
      assert_equal({:size  => 12},   subject.send(:font_settings, [12]))
      assert_equal({:color => '#FFFFFF'}, subject.send(:font_settings, ['#FFFFFF']))
      assert_equal({:name  => 'Arial'},  subject.send(:font_settings, ['Arial']))
    end

    should "translate style directives" do
      assert_equal({:bold   => true}, subject.send(:font_settings, [:bold]))
      assert_equal({:italic => true}, subject.send(:font_settings, [:italic]))
      assert_equal({:shadow => true}, subject.send(:font_settings, [:shadow]))
      assert_equal({:alignment => :subscript},   subject.send(:font_settings, [:subscript]))
      assert_equal({:alignment => :superscript}, subject.send(:font_settings, [:superscript]))
      assert_equal({:strike_through => true}, subject.send(:font_settings, [:strikethrough]))
    end

    should "translate underline directives" do
      assert_equal({:underline => :single}, subject.send(:font_settings, [:underline]))
      assert_equal({:underline => :double}, subject.send(:font_settings, [:double_underline]))
      assert_equal({:underline => :single_accounting}, subject.send(:font_settings, [:accounting_underline]))
      assert_equal({:underline => :double_accounting}, subject.send(:font_settings, [:double_accounting_underline]))
    end

  end




  class XmlssWriterBgSettingsTests < XmlssWriterStyleSettingsTests
    desc "bg settings"

    should "translate color directives" do
      assert_equal({:color => '#FFFFFF', :pattern => :solid}, subject.send(:bg_settings, ['#FFFFFF']))
    end

    should "translate pattern directives" do
      assert_equal({:pattern => :solid}, subject.send(:bg_settings, [:solid]))
      assert_equal({
        :pattern => :horz_stripe,
        :pattern_color => '#0000FF'
      }, subject.send(:bg_settings, [{:horz_stripe => '#0000FF'}]))
    end

  end





  class XmlssWriterBorderSettingsTests < XmlssWriterStyleSettingsTests
    desc "border settings"

    should "translate color directives" do
      assert_equal({:color => '#FFFFFF'}, subject.send(:border_settings, ['#FFFFFF']))
    end

    should "translate position directives" do
      assert_equal({:position => :top}, subject.send(:border_settings, [:top]))
    end

    should "translate weight directives" do
      assert_equal({:weight => :thick}, subject.send(:border_settings, [:thick]))
    end

    should "translate line_style directives" do
      assert_equal({:line_style => :dot}, subject.send(:border_settings, [:dot]))
    end

    should "translate position specific directives" do
      assert_equal({
        :position => :left,
        :color => '#FFFFFF',
        :weight => :thin
      }, subject.send(:border_left_settings, ['#FFFFFF', :thin]))
    end

  end



  class XmlssWriterParseSettingsTests < XmlssWriterStyleSettingsTests
    desc "settings"

    should "parse Osheet style objs for their settings" do
      assert_equal({
        :align => {
          :horizontal => :center
        }
      }, subject.send(:style_settings, @workbook.styles.first))

      assert_equal({
        :border_top => {
          :position=>:top,
          :color=>"#FF0000",
          :weight=>:thin
        },
        :border_right => {
          :position=>:right,
          :color=>"#FF0000",
          :weight=>:thin
        },
        :border_bottom => {
          :position=>:bottom,
          :color=>"#FF0000",
          :weight=>:thin
        },
        :border_left => {
          :position=>:left,
          :color=>"#FF0000",
          :weight=>:thin
        }
      }, subject.send(:style_settings, @workbook.styles.last))
    end

    should "merge style settings from multiple Osheet style objs" do
      set1 = {
        :font => {
          :color => '#FF0000',
          :name => "Arial"
        }
      }
      set2 = {
        :font => {
          :color => '#0000FF',
          :size => 12
        }
      }
      set3 = {
        :align => {
          :horizontal => :center
        }
      }

      # should concat keys in both sets
      assert_equal({
        :font => {
          :color => '#0000FF',
          :name => "Arial",
          :size => 12
        }
      }, subject.send(:merged_settings, set1.dup, set2.dup))

      # should add keys not in first set
      assert_equal({
        :font => {
          :color => '#0000FF',
          :size => 12
        },
        :align => {
          :horizontal => :center
        }
      }, subject.send(:merged_settings, set2.dup, set3.dup))

    end

    should "set its value given its set of styles" do
      assert_equal({
        :align => {
          :horizontal => :center
        },
        :font => {
          :bold => true,
          :italic => true,
          :size => 14
        },
        :bg => {
          :pattern => :solid,
          :color => "#FF0000"
        },
        :border_top => {
          :position => :top,
          :color => "#FF0000",
          :weight => :thin
        },
        :border_right => {
          :position => :right,
          :color => "#FF0000",
          :weight => :thin
        },
        :border_bottom => {
          :position => :bottom,
          :color => "#FF0000",
          :weight => :thin
        },
        :border_left => {
          :position => :left,
          :color => "#FF0000",
          :weight => :thin
        }
      }, XmlssWriter::StyleSettings.new(@workbook.styles).value)
    end
  end

end

