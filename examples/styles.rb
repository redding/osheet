# To run:
# $ bundle install
# $ bundle exec ruby examples/styles.rb
# $ open examples/styles.xls

require 'rubygems'
require 'osheet'

Osheet::Workbook.new {
  title "styles"
  template(:cell, :styled) { |style, attribute|
    data attribute == :wrap ? (attribute.to_s+' ')*20 : attribute.to_s
    style_class "#{style} #{attribute}"
  }

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

    (0..3).each do
      column {
        width 100
      }
    end

    { 'Horizontal alignment' => [:left, :center, :right],
      'Vertical alignment'   => [:top,  :middle, :bottom],
      'Wrap text'            => [:wrap],
      'Rotate text'          => [:rotA, :rotB, :rotC]
    }.each do |k,v|
      row {
        height 50
        v.each {|a| cell(:styled, 'align', a) }
      }
    end
  }



  # font styles
  style('.font.underline') { font :underline }
  style('.font.double_underline') { font :double_underline }
  style('.font.accounting_underline') { font :accounting_underline }
  style('.font.double_accounting_underline') { font :double_accounting_underline }
  style('.font.subscript') { font :subscript }
  style('.font.superscript') { font :superscript }
  style('.font.strikethrough') { font :strikethrough }
  style('.font.shadow') { font :shadow }
  style('.font.bold') { font :bold }
  style('.font.italic') { font :italic }
  style('.font.sizeA') { font 6 }
  style('.font.sizeB') { font 14 }
  style('.font.colorA') { font '#FF0000' }
  style('.font.colorB') { font '#00FF00' }

  worksheet {
    name "font"

    (0..5).each do
      column {
        width 100
      }
    end

    row {
      [:underline, :double_underline, :accounting_underline, :double_accounting_underline].each do |a|
        cell {
          data a.to_s
          style_class "font #{a}"
        }
      end
    }
    row {
      [:subscript, :superscript, :strikethrough, :shadow].each do |a|
        cell {
          data a.to_s
          style_class "font #{a}"
        }
      end
    }
    row {
      [:bold, :italic].each do |a|
        cell {
          data a.to_s
          style_class "font #{a}"
        }
      end
    }
    row {
      [:sizeA, :sizeB].each do |a|
        cell {
          data a.to_s
          style_class "font #{a}"
        }
      end
    }
    row {
      [:colorA, :colorB].each do |a|
        cell {
          data a.to_s
          style_class "font #{a}"
        }
      end
    }
  }



  # bg styles
  style('.bg.color') {
    bg '#FF0000'
    font '#FFFFFF'
  }
  style('.bg.pattern') {
    bg :horz_stripe
  }
  style('.bg.pattern.color') {
    bg '#FF0000', :horz_stripe => '#000000'
    font '#FFFFFF'
  }

  worksheet {
    name "bg"

    column {
      width 100
    }

    row {
      height 50
      cell {
        style_class "bg color"
        data 'COLOR'
      }
    }
    row {
      height 50
      cell {
        style_class "bg pattern"
        data 'PATTERN'
      }
    }
    row {
      height 50
      cell {
        style_class "bg pattern color"
        data 'PATTERN COLOR'
      }
    }
  }



  # border styles
  style('.border.top.color')      { border_top '#FF0000' }
  style('.border.right.color')    { border_right '#00FF00' }
  style('.border.bottom.color')   { border_bottom '#0000FF' }
  style('.border.left.color')     { border_left '#FFFF00' }
  style('.border.top.weight')     { border_top :hairline }
  style('.border.right.weight')   { border_right :thin }
  style('.border.bottom.weight')  { border_bottom :medium }
  style('.border.left.weight')    { border_left :thick }
  style('.border.top.style')     { border_top :continuous }
  style('.border.right.style')   { border_right :dash }
  style('.border.bottom.style')  { border_bottom :dot }
  style('.border.left.style')    { border_left :dash_dot }
  style('.border.all') {
    border :continuous, :thick, '#00FFFF'
  }

  worksheet {
    name "border"

    column {
      width 20
    }
    column {
      width 200
    }

    row {}
    row {
      height 50
      cell {}
      cell {
        style_class "border top color weight style"
        data 'top red hairline continuous'
      }
    }
    row {}
    row {
      height 50
      cell {}
      cell {
        style_class "border right color weight style"
        data 'right green thin dash'
      }
    }
    row {}
    row {
      height 50
      cell {}
      cell {
        style_class "border bottom color weight style"
        data 'bottom blue medium dat'
      }
    }
    row {}
    row {
      height 50
      cell {}
      cell {
        style_class "border left color weight style"
        data 'left yellow thick dast_dot'
      }
    }
    row {}
    row {
      height 50
      cell {}
      cell {
        style_class "border all"
        data 'all aqua'
      }
    }
  }



}.to_file('examples/styles.xls', :format)