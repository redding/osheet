require 'xmlss'

module Osheet
  class XmlssWriter

    attr_reader :workbook

    def initialize(opts={})
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
      ::Xmlss::Column.new
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
