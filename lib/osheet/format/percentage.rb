require 'enumeration'
require 'osheet/format/numeric'

module Osheet::Format

  class Percentage < Osheet::Format::Numeric
    def initialize(opts={})
      super({
        :decimal_places => 2
      }.merge(opts))
    end

    protected

    # used by 'key' in Numeric base class
    def key_prefix
      "percentage"
    end

    # used by 'decimal_places_style' in Numeric base class
    def decimal_places_suffix
      "%"
    end
  end
end
