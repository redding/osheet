module Osheet
  SPREADSHEET_TYPE = "Excel"
  MIME_TYPE = "application/vnd.ms-excel"

  module StyledElement
    def style_class(value); @style_class = value; end
  end

end
