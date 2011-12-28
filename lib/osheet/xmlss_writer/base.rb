require 'fileutils'
module Osheet::XmlssWriter; end
require 'xmlss'
require 'osheet/xmlss_writer/elements'
require 'osheet/xmlss_writer/styles'

module Osheet::XmlssWriter
  class Base
    include Elements
    include Styles

    attr_reader :used_xstyles

    def initialize(opts={})
      @used_xstyles = []
      self.oworkbook =  if opts.has_key?(:workbook)
        opts[:workbook]
      else
        ::Osheet::Workbook.new
      end
    end

    def to_data(xmlss_output_opts={})
      warn "[DEPRECATION] `to_data` is deprecated and will be removed in v1.0.0.  Please use `to_file` directly instead."
      self.xworkbook(xmlss_output_opts).to_s
    end

    def to_file(file_path, xmlss_output_opts={})
      self.xworkbook(xmlss_output_opts).to_file(file_path)
    end




    def oworkbook=(value)
      unless value.kind_of?(::Osheet::Workbook)
        raise ArgumentError, "'#{value.inspect}' is not an Osheet::Workbook"
      end
      @oworkbook = value
    end

    def xworkbook(xmlss_output_opts={})
      @used_xstyles = []
      ::Xmlss::Workbook.new(:output => xmlss_output_opts).tap do |xwkbk|
        @oworkbook.worksheets.each { |sheet| worksheet(xwkbk, sheet) }
      end
    end

  end
end
