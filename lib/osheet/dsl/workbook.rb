require 'osheet/base'
require 'osheet/worksheet'

# === Usage
#
#   require 'osheet'
#
#   Osheet::Workbook.configure do |book|
#     book.worksheet ...
#     book.worksheet ...
#   end

module Osheet
  class Workbook < Osheet::Base
    
    has :worksheets => "Worksheet"

    def initialize(args={})
      super(args)
    end
    
  end
end
