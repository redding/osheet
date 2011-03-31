module Osheet::XmlssWriter; end
require 'xmlss'
require 'osheet/xmlss_writer/elements'
require 'osheet/xmlss_writer/styles'

module Osheet::XmlssWriter
  class Base
    include Elements
    include Styles

    attr_reader :workbook, :styles

    def initialize(opts={})
      @styles = []
      @ostyles = ::Osheet::StyleSet.new
      self.workbook = opts[:workbook] if opts.has_key?(:workbook)
    end

    def workbook=(oworkbook)
      unless oworkbook.kind_of?(::Osheet::Workbook)
        raise ArgumentError, "'#{oworkbook.inspect}' is not an Osheet::Workbook"
      end
      @ostyles = oworkbook.styles
      @workbook = ::Xmlss::Workbook.new({
        :worksheets => worksheets(oworkbook.worksheets)
      })
    end

  end
end