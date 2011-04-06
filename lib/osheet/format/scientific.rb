require 'enumeration'
require 'osheet/format/numeric'

module Osheet::Format

  class Scientific < Osheet::Format::Numeric
    def initialize(opts={})
      super({
        :decimal_places => 2
      }.merge(opts))
    end

    protected

    # used by 'key' in Numeric base class
    def key_prefix
      "scientific"
    end

    # used by 'decimal_places_style' in Numeric base class
    def decimal_places_suffix
      "E+00"
    end
  end
end
