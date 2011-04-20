require 'osheet/style'
require 'osheet/template'

module Osheet::Mixin

  def self.included(receiver)
    receiver.send(:extend, ClassMethods)
  end

  module ClassMethods
    def style(*selectors, &block)
      instance_variable_set("@s",
        (instance_variable_get("@s") || []) << ::Osheet::Style.new(*selectors, &block)
      )
    end
    def styles
      instance_variable_get("@s") || []
    end

    def template(element, name, &block)
      instance_variable_set("@t",
        (instance_variable_get("@t") || []) << ::Osheet::Template.new(element, name, &block)
      )
    end
    def templates
      instance_variable_get("@t") || []
    end

    def partial(name, &block)
      instance_variable_set("@p",
        (instance_variable_get("@p") || []) << ::Osheet::Partial.new(name, &block)
      )
    end
    def partials
      instance_variable_get("@p") || []
    end
  end

end
