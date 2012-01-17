require 'osheet/partial'

module Osheet
  class Template < Partial

    # this class is a partial that is associated with an osheet element
    # if an element is initialized from a template, the template
    # block will be instance_eval'd for the element being initialized

    ELEMENTS = ['worksheet', 'column', 'row', 'cell']

    def initialize(element, name)
      unless element.respond_to?(:to_s) && ELEMENTS.include?(element.to_s)
        raise ArgumentError, "you can only define a template for #{ELEMENTS.join(', ')} elements."
      end

      @element = element.to_s
      super(name)
    end

  end
end
