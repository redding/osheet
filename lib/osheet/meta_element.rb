module Osheet; end
module Osheet::MetaElement

  def meta(value=nil)
    value.nil? ? instance_variable_get("@meta") : instance_variable_set("@meta", value)
  end

end
