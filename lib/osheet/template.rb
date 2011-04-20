require 'osheet/partial'

module Osheet
  class Template < Partial

    # this class is a partial that is associated with an osheet element
    #  if an element is initialized from a template, the template
    #  block will be instance_eval'd for the element being initialized

    include Instance

    ELEMENTS = ['worksheet', 'column', 'row', 'cell']

    def initialize(element, name)
      unless element.respond_to?(:to_s) && ELEMENTS.include?(element.to_s)
        raise ArgumentError, "you can only define a template for #{ELEMENTS.join(', ')} elements."
      end

      set_ivar(:element, element.to_s)
      super(name)
    end

    def element; get_ivar(:element); end
    def element=(v); set_ivar(:element, v); end

  end
end
