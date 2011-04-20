require 'osheet/instance'
require 'osheet/associations'
require 'osheet/markup_element'
require 'osheet/style_set'
require 'osheet/template_set'
require 'osheet/partial_set'
require 'osheet/worksheet'
require 'osheet/xmlss_writer'

module Osheet
  class Workbook
    include Instance
    include Associations
    include MarkupElement

    hm :worksheets

    def initialize(&block)
      set_ivar(:title, nil)
      set_ivar(:styles, StyleSet.new)
      set_ivar(:templates, TemplateSet.new)
      set_ivar(:partials, PartialSet.new)
      if block_given?
        set_binding_ivars(block.binding)
        instance_eval(&block)
      end
    end

    def title(value=nil)
      !value.nil? ? set_ivar(:title, value) : get_ivar(:title)
    end

    def style(*selectors, &block); push_ivar(:styles, Style.new(*selectors, &block)); end
    def styles
      get_ivar(:styles)
    end
    def template(element, name, &block); push_ivar(:templates, Template.new(element, name, &block)); end
    def templates
      get_ivar(:templates)
    end
    def partial(name, &block); push_ivar(:partials, Partial.new(name, &block)); end
    def partials
      get_ivar(:partials)
    end

    def attributes
      { :title => get_ivar(:title) }
    end

    def use(mixin)
      (mixin.styles || []).each{ |s| push_ivar(:styles, s) }
      (mixin.templates || []).each{ |t| push_ivar(:templates, t) }
      (mixin.partials || []).each{ |p| push_ivar(:partials, p) }
    end

    def writer
      XmlssWriter::Base.new(:workbook => self)
    end

    [:to_data, :to_file].each do |meth|
      define_method(meth) {|*args| writer.send(meth, *args) }
    end

  end
end
