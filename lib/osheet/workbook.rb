require 'osheet/partial'
require 'osheet/template'
require 'osheet/workbook_element'
require 'osheet/workbook_api'

module Osheet

  class Workbook

    # This 'Workbook' class is really just a scope for workbook builds to run
    # in.  All actually workbook metadata is behavior is handled by the
    # 'WorkbookElement' class

    class ElementStack < ::Array; end

    include WorkbookApi

    def initialize(writer=nil, data={}, &build)
      # apply :data options to workbook scope
      data ||= {}
      if (data.keys.map(&:to_s) & self.public_methods.map(&:to_s)).size > 0
        raise ArgumentError, "data conflicts with workbook public methods."
      end
      metaclass = class << self; self; end
      data.each {|key, value| metaclass.class_eval { define_method(key){value} }}

      # setup the writer, element stack, and workbook_element
      writer.bind(self) if writer
      @_osheet_writer = writer
      @_osheet_element_stack = Workbook::ElementStack.new
      @_osheet_workbook_element = WorkbookElement.new

      # push the workbook element onto the element stack
      element_stack.push(workbook)

      # run any instance workbook build given
      instance_eval(&build) if build
    end

    def writer
      @_osheet_writer
    end

    def element_stack
      @_osheet_element_stack
    end

    def workbook_element
      @_osheet_workbook_element
    end
    alias_method :workbook, :workbook_element

    # use a mixin to define its markup handlers (templates, partials, and styles)
    # in your workbook scope
    # all blocks in mixins will be instance eval'd in the workbook scope
    # and should be written as such
    def use(mixin)
      # templates and partials are just blocks themselves so they just need to
      # be added to the workbook element
      # they will be instance eval'd when they get used
      (mixin.templates || []).each { |mt| template(*mt.args, &mt.build) }
      (mixin.partials  || []).each { |mp| partial(*mp.args, &mp.build)  }

      # styles not only need to be added to the workbook element, but
      # any build passed to the style needs to be instance eval'd
      (mixin.styles || []).each do |ms|
        StyleBuild.new(self, *ms.args, &ms.build).add do |build|
          instance_eval(&build)
        end
      end
    end

    # add partials to dynamically add markup to your workbook
    # note: you can also define element templates to add element specific
    # markup to your workbook
    def add(partial_name, *args)
      workbook.partials.get(partial_name).tap do |p|
        instance_exec(*args, &p) if p
      end
    end

    # overriding to make less noisy
    def to_str(*args)
      "#<Osheet::Workbook:#{self.object_id} @title=#{workbook.title.inspect}, " +
      "worksheet_count=#{workbook.worksheets.size.inspect}, " +
      "style_count=#{workbook.styles.size.inspect}>"
    end
    alias_method :inspect, :to_str

    # writers are responsible for defining what each of these methods do
    # and what they return
    [:to_s, :to_data, :to_file].each do |meth|
      define_method(meth) {|*args| writer.send(meth, *args) }
    end

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
