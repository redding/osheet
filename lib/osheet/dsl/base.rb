module Osheet; end
module Osheet::Dsl
  class Base

    class << self

      protected

      def defaults(hash={})
        @defaults = hash.merge({
          :style => nil
        })
      end
    end

    def initialize(&block)
      @style = nil
      defaults
      instance_eval(&block) if block
    end

    def style(style); @style = style; end

    private

    def defaults
      (@@defaults || {}).each do |d, v|
        instance_variable_set("@d", v)
      end
    end

  end
end
