module Osheet
  class Partial < ::Proc

    # this class is essentially a way to define a named definition
    # block with arguments.  If the partial is added to an element,
    # any markup in it's definition block is applied to the element.
    # ie. the definition block will be instance_eval'd on workbook.
    attr_reader :name

    def initialize(name)
      unless name.kind_of?(::String) || name.kind_of?(::Symbol)
        raise ArgumentError, "please use a string or symbol for the partial name."
      end

      @name = name.to_s
      super()
    end

  end
end

