require 'osheet/instance'
require 'osheet/meta'
require 'osheet/mixin'

require 'osheet/workbook/style_set'
require 'osheet/workbook/template_set'
require 'osheet/workbook/partial_set'
require 'osheet/workbook/worksheet_set'
require 'osheet/workbook/styles'
require 'osheet/workbook/elements'

# require 'osheet/xmlss_writer'

module Osheet
  class Workbook
    include Instance
    include Meta
    include Workbook::Styles
    include Workbook::Elements

    def initialize(writer=nil, data={}, &build)
      # setup reference collections
      set_ivar(:templates,  TemplateSet.new)
      set_ivar(:partials,   PartialSet.new)
      set_ivar(:styles,     StyleSet.new)
      set_ivar(:worksheets, WorksheetSet.new)

      # apply :data options to workbook scope
      data ||= {}
      if (data.keys.map(&:to_s) & self.public_methods.map(&:to_s)).size > 0
        raise ArgumentError, "data conflicts with workbook public methods."
      end
      metaclass = class << self; self; end
      data.each {|key, value| metaclass.class_eval { define_method(key){value} }}

      # setup writer
      set_ivar(:writer, writer)

      # run any instance workbook build given
      instance_eval(&build) if build
    end

    def template(*args, &block)
      push_ivar(:templates, Template.new(*args, &block))
    end
    def templates; get_ivar(:templates); end

    def partial(*args, &block)
      push_ivar(:partials, Partial.new(*args, &block))
    end
    def partials; get_ivar(:partials); end

    def use(mixin)
      (mixin.templates || []).each{ |t| push_ivar(:templates, t) }
      (mixin.partials  || []).each{ |p| push_ivar(:partials,  p) }
      (mixin.styles    || []).each{ |s| push_ivar(:styles,    s) }
    end

    def add(partial_name, *args)
      self.partials.get(partial_name).tap do |p|
        instance_exec(*args, &p) if p
      end
    end

    def writer
      get_ivar(:writer)
    end

    # TODO: still needed??
    # def attributes
    #   { :title => get_ivar(:title) }
    # end

    # TODO: writer should handle all this
    # def writer
    #   XmlssWriter::Base.new(:workbook => self)
    # end

    # [:to_data, :to_file].each do |meth|
    #   define_method(meth) {|*args| writer.send(meth, *args) }
    # end

  end
end
