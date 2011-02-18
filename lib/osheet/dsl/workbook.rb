require 'osheet/base'
require 'osheet/worksheet'

module Osheet::Dsl
  class Workbook < Osheet::Dsl::Base

    defaults(
      :title => nil,
      :worksheets => []
    )

    def title(title); @title = title; end
    def worksheet(&block); @worksheets << Worksheet.new(&block); end

  end
end
