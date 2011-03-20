require 'osheet/dsl/worksheet'

module Osheet::Dsl
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
