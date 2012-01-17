require 'osheet/workbook/styles'
require 'osheet/workbook/elements'

require 'osheet/workbook_element'

module Osheet


  class Workbook

    # This 'Workbook' class is really just a scope for workbook builds to run
    # in.  All actually workbook metadata is behavior is handled by the
    # 'WorkbookElement' class

    class ElementStack < ::Array; end

    include Workbook::Styles
    include Workbook::Elements

    def initialize(writer=nil, data={}, &build)
      # apply :data options to workbook scope
      data ||= {}
      if (data.keys.map(&:to_s) & self.public_methods.map(&:to_s)).size > 0
        raise ArgumentError, "data conflicts with workbook public methods."
      end
      metaclass = class << self; self; end
      data.each {|key, value| metaclass.class_eval { define_method(key){value} }}

      # setup the writer, element stack, and workbook_element
      set_ivar(:writer, writer)
      set_ivar(:element_stack, Workbook::ElementStack.new)
      set_ivar(:workbook_element, WorkbookElement.new)

      # push the workbook element onto the element stack
      element_stack.push(workbook)

      # run any instance workbook build given
      instance_eval(&build) if build
    end

    def writer
      get_ivar(:writer)
    end

    def element_stack
      get_ivar(:element_stack)
    end

    # reference API

    def workbook_element
      get_ivar(:workbook_element)
    end
    alias_method :workbook, :workbook_element

    def worksheets
      workbook.worksheets
    end

    def columns
      worksheets.last.columns
    end

    def rows
      worksheets.last.rows
    end

    def cells
      rows.last.cells
    end

    private

    OSHEET_IVAR_NS = "_osheet_"

    def get_ivar(name)
      instance_variable_get(ivar_name(name))
    end

    def set_ivar(name, value)
      instance_variable_set(ivar_name(name), value)
    end

    def push_ivar(name, value)
      get_ivar(name) << value
    end

    def ivar_name(name)
      "@#{OSHEET_IVAR_NS}#{name}"
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



  class Workbook::ElementStack

    # this class is just a wrapper to Array.  I want to treat this as a
    # stack of objects for the workbook DSL to reference.  I need to push
    # an object onto the stack, reference it using the 'current' method,
    # and pop it off the stack when I'm done.

    def initialize
      super
    end

    def push(*args)
      super
    end

    def pop(*args)
      super
    end

    def current
      self.last
    end

    def size(*args)
      super
    end

    def using(obj, &block)
      push(obj)
      block.call if !block.nil?
      pop
    end

  end


end
