require 'osheet/style_set'
require 'osheet/template_set'
require 'osheet/worksheet'
require 'osheet/xmlss_writer'

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
      { :title => @title }
    end

    def writer
      XmlssWriter::Base.new(:workbook => self)
    end

    [:to_data, :to_file].each do |meth|
      define_method(meth) {|*args| writer.send(meth, *args) }
    end

  end
end
