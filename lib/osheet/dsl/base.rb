module Osheet; end
module Osheet::Dsl
  class Base

    @@defaults = nil

    class << self

      def defaults(hash={})
        @@defaults = hash.merge({
          :style => nil
        })
      end
    end

    def initialize(&block)
      defaults
      instance_eval(&block) if block
    end

    def style(value); self.style_value = value; end

    protected

    def method_missing(meth, *args, &block)
      # handle data access reads and writes
      # => only methods ending in '_value' or '_set'
      # => '=' operator: write to data value
      # => '<<' operator: write to data set
      if meth.to_s =~ /(.+)(_value|_set)(=|<{2}|)/
        data_access($1.to_sym, $3, args.first)
      else
        super # continue method_missing handling
      end
    end

    private

    def defaults
      (@@defaults || {}).each do |d, v|
        self.send("#{d}_value=", v)
      end
    end

    def data_access(key, operator, data)
      @data ||= {}
      if operator == '='
        # write data value
        @data[key] = data
      elsif operator == '<<'
        @data[key] ||= []
        @data[key] << data
      else
        # read
        @data[key]
      end
    end

  end
end
