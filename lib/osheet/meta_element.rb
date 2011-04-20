module Osheet::MetaElement

  def meta(value=nil)
    value.nil? ? get_ivar(:meta) : set_ivar(:meta, value)
  end

end
