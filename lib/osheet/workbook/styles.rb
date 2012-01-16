require 'osheet/style'
module Osheet; end
class Osheet::Workbook; end

module Osheet::Workbook::Styles

  def styles; get_ivar(:styles); end

  def style(*args, &block)
    if args.empty?
      self.styles.last
    else
      Osheet::Style.new(*args).tap do |style|
        push_ivar(:styles, style)
        writer.style(style, &block)
      end
    end
  end

  Osheet::Style::SETTINGS.each do |setting|
    define_method(setting) do |*args|
      style.send(setting, *args)
    end
  end

  def border(*args)
    style.border(*args)
  end

end
