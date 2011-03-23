module Osheet
  class Template

    # this class is essentially a way to define a named initializer
    #  block and associate that with an osheet element
    #  if an element is initialized from a template, the template
    #  block will be instance_eval'd for the element being initialized

    ELEMENTS = ['worksheet', 'column', 'row', 'cell']

    attr_accessor :element, :name, :block

    def initialize(element, name, &block)
      verify(element, name, block)
      @element = element.to_s
      @name = name.to_s
      @block = block
    end

    private

    def verify(element, name, block)
      unless element.respond_to?(:to_s) && ELEMENTS.include?(element.to_s)
        raise ArgumentError, "you can only define a template for #{ELEMENTS.join(', ')} elements."
      end
      unless name.kind_of?(::String) || name.kind_of?(::Symbol)
        raise ArgumentError, "please use a string or symbol for the template name."
      end
      if block.nil?
        raise ArgumentError, "you must provide a block for this template to use."
      end
    end

  end
end
