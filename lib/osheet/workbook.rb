require 'osheet/style'
require 'osheet/template'
require 'osheet/template_set'
require 'osheet/worksheet'

module Osheet
  class Workbook
    include Associations

    hm :worksheets
    attr_reader :styles, :templates

    def initialize(&block)
      @title = nil
      @styles = []
      @templates = TemplateSet.new
      instance_eval(&block) if block
    end

    def title(title); @title = title; end
    def style(*selectors, &block); @styles << Style.new(*selectors, &block); end
    def template(element, name, &block); @templates << Template.new(element, name, &block); end

  end
end
