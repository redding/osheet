module Osheet::Instance

  private

  OSHEET_IVAR_NS = "_osheet_"

  def get_ivar(name)
    instance_variable_get(ivar_name(name))
  end

  def set_ivar(name, value)
    instance_variable_set(ivar_name(name), value)
  end

  def push_ivar(name, value)
    # if name == :templates
    #   puts "name: #{name.inspect}"
    #   puts "givar: #{get_ivar(name).inspect}"
    #   puts "value: #{value.inspect}"
    # end
    get_ivar(name) << value
  end

  def ivar_name(name)
    "@#{OSHEET_IVAR_NS}#{name}"
  end
end
