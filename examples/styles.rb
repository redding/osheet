# To run:
# $ bundle install
# $ bundle exec ruby examples/styles.rb
# $ open examples/styles.xls

require 'rubygems'
require 'osheet'

Osheet::Workbook.new {
  title "styles"

  # align styles
  style('.align.left') { align :left }
  style('.align.center') { align :center }
  style('.align.right') { align :right }
  style('.align.top') { align :top }
  style('.align.middle') { align :middle }
  style('.align.bottom') { align :bottom }
  style('.align.wrap') { align :wrap }
  style('.align.rotA') { align 90 }
  style('.align.rotB') { align -90 }
  style('.align.rotC') { align 45 }

  worksheet {
    name "align"

    column {
      width 250
      meta(:label => 'style')
    }
    (0..3).each do
      column {
        width 100
        meta(:label => 'example')
      }
    end

    # alignment styles
    { 'Horizontal alignment' => [:left, :center, :right],
      'Vertical alignment'   => [:top,  :middle, :bottom],
      'Wrap text'            => [:wrap],
      'Rotate text'          => [:rotA, :rotB, :rotC]
    }.each do |k,v|
      row {
        height 50
        cell {
          data k
        }
        v.each do |a|
          cell {
            data a == :wrap ? (a.to_s+' ')*20 : a.to_s
            style_class "align #{a}"
          }
        end
      }
    end
  }



}.to_file('examples/styles.xls')