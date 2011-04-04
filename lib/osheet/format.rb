module Osheet
  class Format
    VALUES = [
      :general,:number, :currency, :accounting,
      :date, :time, :percentage, :fraction, :scientific,
      :text, :special, :custom
    ]

    attr_accessor :value, :options

    def initialize(value=nil, options=nil)
      self.value = value || :general
      self.options = options || {}
    end

    def value=(value)
      @options ||= default_options(value)
      @value = value
    end

    def options=(value={})
      verify(value || {})
      @options.merge!(value || {})
    end

    def style
      nil
    end

    private

    def default_options(value)
      case value
      when :general
        {}
      when :number
        {:decimal_places => 0, :comma_separator => false, :display_negatives => :black}
      else
        raise ArgumentError, "'#{value.inspect}' is not a valid format"
      end
    end

    def verify(options)
      if options.kind_of?(::Hash)
        if options.has_key?(:decimal_places) && (dp = options[:decimal_places])
          if !dp.kind_of?(::Fixnum) || dp < 0
            raise ArgumentError, ":decimal_places must be a positive Fixnum."
          end
        end
      else
        raise ArgumentError, "Format options must be specified with a Hash."
      end
    end

  end
end
