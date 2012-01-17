module Osheet; end
module Osheet::StyledElement

  def style_class(value=nil)
    if value.nil?
      instance_variable_get("@style_class")
    else
      instance_variable_set("@style_class", verify_style_class(value))
    end
  end

  private

  def verify_style_class(style_class)
    if !style_class.kind_of?(::String) || invalid_style_class?(style_class)
      raise ArgumentError, "invalid style_class: '#{style_class}', cannot contain '.' or '>'"
    else
      style_class
    end
  end

  def invalid_style_class?(style_class)
    style_class =~ /\.+/ ||
    style_class =~ />+/
  end
end
