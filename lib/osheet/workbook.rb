require 'osheet/style'
require 'osheet/template'
require 'osheet/template_set'
require 'osheet/worksheet'

module Osheet
  class Workbook

    attr_reader :styles, :templates

    def initialize(&block)
      @title = nil
      @worksheets = []
      @styles = []
      @templates = TemplateSet.new
      instance_eval(&block) if block
    end

    def title(title); @title = title; end
    def style(selector, &block); @styles << Style.new(selector, &block); end
    def template(element, name, &block); @templates << Template.new(element, name, &block); end
    def worksheet(&block); @worksheets << Worksheet.new(&block); end

  end
end
