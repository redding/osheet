module Osheet; end
class Osheet::Workbook; end

module Osheet::Workbook::Styles

  def styles; get_ivar(:styles); end

  def style(*args, &block)
    push_ivar(:styles, Style.new(*args, &block))
  end

end
