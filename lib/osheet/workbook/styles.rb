require 'osheet/style'
module Osheet; end
class Osheet::Workbook; end

module Osheet::Workbook::Styles

  def styles
    workbook.styles
  end

  def style(*args, &block)
    if args.empty? && block.nil?
      self.styles.last
    else
      Osheet::Style.new(*args).tap do |style|
        element_stack.current.style(style)
        element_stack.using(style) do
          writer ? writer.style(style, &block) : block.call
        end
      end
    end
  end

  Osheet::Style::SETTINGS.each do |setting|
    define_method(setting) do |*args|
      element_stack.current.send(setting, *args)
    end
  end

  def border(*args)
    element_stack.current.border(*args)
  end

end
