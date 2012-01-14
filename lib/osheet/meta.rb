module Osheet::Meta

  def meta(value=nil)
    value.nil? ? get_ivar(:meta) : set_ivar(:meta, value)
  end

end
