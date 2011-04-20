module Osheet

  MIME_TYPE = "application/vnd.ms-excel"

  class << self
    # used to register an appropriate template handler
    # and register a mime type if necessary
    def register
      ::Mime::Type.register MIME_TYPE, :xls if defined? ::Mime::Type
      require 'osheet/template_handler'
    end
  end

end

require 'osheet/instance'
require 'osheet/partial'
require 'osheet/associations'
require 'osheet/mixin'

require 'osheet/markup_element'
require 'osheet/styled_element'
require 'osheet/meta_element'
require 'osheet/workbook_element'
require 'osheet/worksheet_element'

if defined? Rails::Railtie
  require 'osheet/railtie'
end

require 'osheet/workbook'
