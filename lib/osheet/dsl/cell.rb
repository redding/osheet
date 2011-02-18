require 'osheet/base'

module Osheet::Dsl
  class Cell < Osheet::Dsl::Base

    defaults(
      :data => nil,
      :format => nil,
      :rowspan => 1,
      :colspan => 1
    )

    def data(data); @data = data; end
    def format(format); @format = format; end
    def rowspan(rowspan); @rowspan = rowspan; end
    def colspan(colspan); @colspan = colspan; end

  end
end
