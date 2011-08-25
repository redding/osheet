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
    get_ivar(name) << value
  end

  def ivar_name(name)
    "@#{OSHEET_IVAR_NS}#{name}"
  end

  def set_binding_ivars(binding)
    binding.eval('instance_variables').
    reject{|ivar| ivar =~ /^@#{OSHEET_IVAR_NS}/}.
    each do |ivar|
      instance_variable_set(ivar, binding.eval(ivar.to_s))
    end
  end
end
