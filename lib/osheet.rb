module Osheet

  MIME_TYPE = "application/vnd.ms-excel"

  class << self
    # used to register an appropriate template engine
    def register
      require 'osheet/template_engine'
    end
  end

end

require 'osheet/associations'
require 'osheet/workbook_element'
require 'osheet/worksheet_element'
require 'osheet/styled_element'
require 'osheet/meta_element'

require 'osheet/workbook'
