require 'osheet'
require 'xmlss'

require 'osheet/xmlss_writer/style_cache'

module Osheet
  class XmlssWriter

    # The Osheet::XmlssWriter provides the logic/translation needed to drive
    # an xmlss workbook using the Osheet API.  The writer creates an xmlss
    # workbook and uses the builder approach to drive the workbook creation.

    # The writer maintains a set of used xmlss styles and handles creating
    # xmlss style objects as needed and manages style keys

    attr_reader :style_cache, :xmlss_workbook

    def initialize(*args, &block)
      @xmlss_workbook = Xmlss::Workbook.new(Xmlss::Writer.new(*args, &block))
      @osheet_workbook = nil
      @osheet_worksheet_names = []
      @style_cache = nil
    end

    def bind(osheet_workbook)
      @osheet_workbook = osheet_workbook
      @style_cache = StyleCache.new(@osheet_workbook, @xmlss_workbook)
    end

    def to_s
      @xmlss_workbook.to_s
    end
    alias_method :to_data, :to_s

    def to_file(file_path)
      @xmlss_workbook.to_file(file_path)
    end

    # Element writers

    def worksheet(worksheet, &build)
      if @osheet_workbook && @osheet_worksheet_names.include?(worksheet.name.to_s)
        raise ArgumentError, "you can't write two worksheets with the same name ('#{worksheet.name}')"
      end
      @osheet_worksheet_names << worksheet.name.to_s
      @xmlss_workbook.worksheet(worksheet.name, &build)
    end

    def column(column, &build)
      attrs = {
        :width => column.width,
        :auto_fit_width => column.autofit,
        :hidden => column.hidden
      }
      if s = @style_cache.get(column.style_class, column.format)
        attrs[:style_id] = s.id
      end
      @xmlss_workbook.column(attrs, &build)
    end

    def row(row, &build)
      attrs = {
        :height => row.height,
        :auto_fit_height => row.autofit,
        :hidden => row.hidden
      }
      if s = @style_cache.get(row.style_class, row.format)
        attrs[:style_id] = s.id
      end
      @xmlss_workbook.row(attrs, &build)
    end

    def cell(cell, &build)
      attrs = {
        :href => cell.href,
        :index => cell.index,
        :merge_across => cell_merge(cell.colspan),
        :merge_down => cell_merge(cell.rowspan),
        :formula => cell.formula
      }
      if s = @style_cache.get(cell.style_class, cell.format)
        attrs[:style_id] = s.id
      end
      @xmlss_workbook.cell(cell.data, attrs, &build)
    end

    # Element style writers

    # given an elements style_class or format attributes:
    # 1) write a new xmlss style object and
    # 2) set the current element's style_id attribute

    def style(style_class, format=nil)
      @style_cache.get(
        style_class,
        format || Osheet::Format.new(:general)
      ).tap do |xmlss_style|
        @xmlss_workbook.style_id(xmlss_style.id) if xmlss_style
      end
    end

    def colspan(count)
      @xmlss_workbook.merge_across(cell_merge(count))
    end

    def rowspan(count)
      @xmlss_workbook.merge_down(cell_merge(count))
    end

    def name(value)
      @osheet_worksheet_names.pop
      @osheet_worksheet_names << value
      @xmlss_workbook.name(value)
    end

    # Element attribute writers

    [ :width,       # column
      :height,      # row
      :autofit,     # column, row
      :autofit?,    # column, row
      :hidden,      # column, row
      :hidden?,     # column, row
      :data,        # cell
      :format,      # cell
      :href,        # cell
      :formula,     # cell
      :index        # cell
    ].each do |meth|
      define_method(meth) do |*args, &block|
        @xmlss_workbook.send(meth, *args, &block)
      end
    end

    protected

    # convert osheet col/row span value to xmlss merge value
    def cell_merge(span)
      span.kind_of?(::Fixnum) && span > 1 ? span-1 : 0
    end

  end
end
