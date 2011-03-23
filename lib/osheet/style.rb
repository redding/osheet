module Osheet
  class Style

    # this class is essentially a set of collectors for style settings
    #  each setting collects any arguments passed to it and
    #  it is up to the drivers to determine how to use the settings

    BORDERS = [:border_top, :border_right, :border_bottom, :border_left]
    SETTINGS = [:align, :font, :bg_color, :bg_pattern] + BORDERS

    def initialize(&block)
      SETTINGS.each do |setting|
        instance_variable_set("@#{setting}", [])
      end
      instance_eval(&block) if block
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
  end
end
