require 'osheet/dsl/base'

module Osheet::Dsl
  class Cell < Osheet::Dsl::Base

    defaults(
      :data => nil,
      :format => nil,
      :rowspan => 1,
      :colspan => 1
    )

    def data(value); self.data_value = value; end
    def format(value); self.format_value = value; end
    def rowspan(value); self.rowspan_value = value; end
    def colspan(value); self.colspan_value = value; end

  end
end
