module Osheet; end
class Osheet::Workbook; end

module Osheet::Workbook::Elements

  def workbook
    self
  end

  def worksheets; get_ivar(:worksheets); end

  # TODO: test this behavior
  def worksheet(*args, &block)
    if args.empty?
      self.worksheets.last
    else
      push_ivar(:worksheets, Worksheet.new(*args, &block))
    end
  end

end
