module Osheet
  class Style

    # this class is essentially a set of collectors for style settings
    # each setting collects any arguments passed to it and
    # it is up to the writer to determine how to use the settings

    BORDER_POSITIONS = [:top, :right, :bottom, :left]
    BORDERS = BORDER_POSITIONS.collect{|p| "border_#{p}".to_sym}
    SETTINGS = [:align, :font, :bg] + BORDERS

    attr_reader :selectors, :build

    def initialize(*selectors, &build)
      @selectors = verify(selectors)
      @build = build || Proc.new {}
      SETTINGS.each { |s| instance_variable_set("@#{s}", []) }
    end

    def align(*args); @align += args; end
    def font(*args);  @font  += args; end
    def bg(*args);    @bg    += args; end

    def border_top(*args);    @border_top    += args; end
    def border_right(*args);  @border_right  += args; end
    def border_bottom(*args); @border_bottom += args; end
    def border_left(*args);   @border_left   += args; end

    def border(*args)
      BORDERS.each { |border| send(border, *args) }
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
