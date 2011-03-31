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
        # TODO: move to a better location
        assert_kind_of ::Xmlss::Style::Base, subject.send(:style, 'align')

        assert_equal nil, subject.send(:style, 'align').alignment
      end

      should "build style objs for horizontal alignment settings" do
        assert_equal "Left", subject.send(:style, 'align left').alignment.horizontal
        assert_equal "Center", subject.send(:style, 'align center').alignment.horizontal
        assert_equal "Right", subject.send(:style, 'align right').alignment.horizontal
      end

      should "build style objs for vertical alignment settings" do
        assert_equal "Top", subject.send(:style, 'align top').alignment.vertical
        assert_equal "Center", subject.send(:style, 'align middle').alignment.vertical
        assert_equal "Bottom", subject.send(:style, 'align bottom').alignment.vertical
      end

      should "build style objs for text wrap settings" do
        assert_equal true, subject.send(:style, 'align wrap').alignment.wrap_text?
      end

      should "build style objs for text rotation settings" do
        assert_equal 90, subject.send(:style, 'align rotate').alignment.rotate
      end

    end
  end

end
