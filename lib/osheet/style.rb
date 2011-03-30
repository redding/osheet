module Osheet
  class Style

    # this class is essentially a set of collectors for style settings
    #  each setting collects any arguments passed to it and
    #  it is up to the drivers to determine how to use the settings

    BORDERS = [:border_top, :border_right, :border_bottom, :border_left]
    SETTINGS = [:align, :font, :bg_color, :bg_pattern] + BORDERS

    attr_reader :selectors

    def initialize(*selectors, &block)
      @selectors = verify(selectors)
      SETTINGS.each do |setting|
        instance_variable_set("@#{setting}", [])
      end
      instance_eval(&block) if block_given?
    end

    SETTINGS.each do |setting|
      define_method(setting) do |*args|
        instance_variable_set("@#{setting}", instance_variable_get("@#{setting}") + args)
      end
    end

    def border(*args)
      BORDERS.each do |border|
        send(border, *args)
      end
    end

    def attributes
      SETTINGS.inject({}) do |attrs, s|
        attrs[s] = instance_variable_get("@#{s}")
        attrs
      end
    end

    def match?(style_class)
      selectors.inject(false) do |match, s|
        match ||= s.split('.').inject(true) do |result, part|
          result && (part.empty? || style_class.include?(part))
        end
      end
    end

    private

    def verify(selectors)
      selectors.each do |selector|
        if !selector.kind_of?(::String) || invalid?(selector)
          raise ArgumentError, "invalid selector: '#{selector}', selectors must be strings that begin with '.' and con't have spaces or '>'."
        end
      end
    end

    def invalid?(selector)
      selector =~ /\s+/ ||
      selector =~ /^[^.]/ ||
      selector =~ />+/
    end
  end
end
