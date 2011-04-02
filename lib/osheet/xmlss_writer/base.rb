require 'fileutils'
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

    def to_data
      @workbook.styles = @styles
      @workbook.to_xml
    end

    def to_file(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') {|f| f.write self.to_data}
      File.exists?(path) ? path : false
    end

  end
end