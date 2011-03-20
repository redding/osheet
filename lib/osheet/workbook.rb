require 'osheet/worksheet'

module Osheet
  class Workbook

    def initialize(&block)
      @title = nil
      @worksheets = []
      instance_eval(&block) if block
    end

    def title(title); @title = title; end
    def worksheet(&block); @worksheets << Worksheet.new(&block); end

  end
end
