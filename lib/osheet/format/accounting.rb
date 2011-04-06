require 'enumeration'
require 'osheet/format/currency'

module Osheet::Format

  class Accounting < Osheet::Format::Currency

    protected

    # used by 'key' in Numeric base class
    def key_prefix
      "accounting"
    end

    # used by 'numeric_style' in Numeric base class
    def symbol_suffix
      "* "
    end

  end
end
