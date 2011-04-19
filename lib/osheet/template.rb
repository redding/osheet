module Osheet
  class Template < ::Proc

    # this class is essentially a way to define a named initializer
    #  block and associate that with an osheet element
    #  if an element is initialized from a template, the template
    #  block will be instance_eval'd for the element being initialized

    include Instance

    ELEMENTS = ['worksheet', 'column', 'row', 'cell']

    def initialize(element, name)
      verify(element, name)
      set_ivar(:element, element.to_s)
      set_ivar(:name, name.to_s)
      super()
    end

    [:element, :name].each do |meth|
      define_method(meth) do
        get_ivar(meth)
      end
      define_method("#{meth}=") do |value|
        set_ivar(meth, value)
      end
    end

    private

    def verify(element, name)
      unless element.respond_to?(:to_s) && ELEMENTS.include?(element.to_s)
        raise ArgumentError, "you can only define a template for #{ELEMENTS.join(', ')} elements."
      end
      unless name.kind_of?(::String) || name.kind_of?(::Symbol)
        raise ArgumentError, "please use a string or symbol for the template name."
      end
    end

  end
end
