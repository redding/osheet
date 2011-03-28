require 'xmlss'

module Osheet
  class XmlssWriter

    attr_reader :workbook, :styles

    def initialize(opts={})
      @styles = []
      self.workbook = opts[:workbook] if opts.has_key?(:workbook)
    end

    def workbook=(oworkbook)
      unless oworkbook.kind_of?(::Osheet::Workbook)
        raise ArgumentError, "'#{oworkbook.inspect}' is not an Osheet::Workbook"
      end
      @workbook = ::Xmlss::Workbook.new({
        :worksheets => worksheets(oworkbook.worksheets)
      })
    end

    protected

    def style(style_class, format=nil)
      key = style_key(style_class, format)
      xmlss_style = @styles.find{|style| style.id == key}
      if xmlss_style.nil?
        @styles << (xmlss_style = ::Xmlss::Style::Base.new(key))
      end
      xmlss_style
    end

    def style_key(style_class, format)
      (style_class || '').strip.split(/\s+/).collect do |c|
        ".#{c}"
      end.join('') + "..#{format}"
    end

    def worksheets(oworksheets)
      oworksheets.collect do |oworksheet|
        worksheet(oworksheet)
      end
    end
    def worksheet(oworksheet)
      ::Xmlss::Worksheet.new(oworksheet.attributes[:name], {
        :table => table(oworksheet)
      })
    end
    def table(oworksheet)
      ::Xmlss::Table.new({
        :columns => columns(oworksheet.columns),
        :rows => rows(oworksheet.rows)
      })
    end

    def columns(ocolumns)
      ocolumns.collect do |ocolumn|
        column(ocolumn)
      end
    end
    def column(ocolumn)
      ::Xmlss::Column.new({
        :style_id => style(ocolumn.attributes[:style_class]).id,
        :width => ocolumn.attributes[:width],
        :auto_fit_width => ocolumn.attributes[:autofit],
        :hidden => ocolumn.attributes[:hidden]
      })
    end

    def rows(orows)
      orows.collect do |orow|
        row(orow)
      end
    end
    def row(orow)
      ::Xmlss::Row.new
    end

  end
end
