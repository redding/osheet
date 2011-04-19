module Osheet
  class Style

    # this class is essentially a set of collectors for style settings
    #  each setting collects any arguments passed to it and
    #  it is up to the drivers to determine how to use the settings

    include Instance

    BORDER_POSITIONS = [:top, :right, :bottom, :left]
    BORDERS = BORDER_POSITIONS.collect{|p| "border_#{p}".to_sym}
    SETTINGS = [:align, :font, :bg] + BORDERS

    def initialize(*selectors, &block)
      set_ivar(:selectors, verify(selectors))
      SETTINGS.each {|setting| set_ivar(setting, [])}
      if block_given?
        set_binding_ivars(block.binding)
        instance_eval(&block)
      end
    end

    def selectors
      get_ivar(:selectors)
    end

    SETTINGS.each do |setting|
      define_method(setting) do |*args|
        set_ivar(setting, get_ivar(setting) + args)
      end
    end

    def border(*args)
      BORDERS.each do |border|
        send(border, *args)
      end
    end

    def attributes
      SETTINGS.inject({}) do |attrs, s|
        attrs[s] = get_ivar(s)
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
