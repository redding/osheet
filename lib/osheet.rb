require 'osheet/base'
require 'osheet/workbook'
require 'osheet/worksheet'

module Osheet
  SPREADSHEET_TYPE = "Excel"
  MIME_TYPE = "application/vnd.ms-excel"
=begin
  @@config = Config.new
  
  class << self
    
    # Configuration accessors for Rack::Less
    # (see config.rb for details)
    def configure
      yield @@config if block_given?
    end
    def config
      @@config
    end
    def config=(value)
      @@config = value
    end
    
    # Combinations config convenience method
    def combinations(key=nil)
      @@config.combinations(key)
    end

  end
=end
end
