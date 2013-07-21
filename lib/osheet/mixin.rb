module Osheet::Mixin

  def self.included(receiver)
    receiver.send(:extend, ClassMethods)
  end

  class Args

    attr_reader :args, :build

    def initialize(*args, &build)
      @args = args
      @build = build || Proc.new {}
    end

  end

  module ClassMethods

    def style(*selectors, &build)
      instance_variable_set("@s",
        (instance_variable_get("@s") || []) << Args.new(*selectors, &build)
      )
    end

    def styles
      instance_variable_get("@s") || []
    end

    def template(element, name, &build)
      instance_variable_set("@t",
        (instance_variable_get("@t") || []) << Args.new(element, name, &build)
      )
    end

    def templates
      instance_variable_get("@t") || []
    end

    def partial(name, &build)
      instance_variable_set("@p",
        (instance_variable_get("@p") || []) << Args.new(name, &build)
      )
    end

    def partials
      instance_variable_get("@p") || []
    end

  end

end
