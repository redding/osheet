require 'osheet/style'
require 'osheet/style_set'
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
      @styles = StyleSet.new
      @templates = TemplateSet.new
      instance_eval(&block) if block_given?
    end

    def title(title); @title = title; end
    def style(*selectors, &block); @styles << Style.new(*selectors, &block); end
    def template(element, name, &block); @templates << Template.new(element, name, &block); end

    def attributes
      {
        :title => @title
      }
    end

    # def data(driver=:xmlss)
    #   Driver.new(driver, self).data
    # end
    # alias_method :to_data, :to_xls

  end
end
