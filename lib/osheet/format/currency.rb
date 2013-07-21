require 'enumeration'
require 'osheet/format/numeric'

module Osheet::Format
  class Currency < Osheet::Format::Numeric

    def initialize(opts={})
      super({
        :symbol => 'dollar',
        :decimal_places => 2,
        :comma_separator => true
      }.merge(opts))
    end

    protected

    # used by 'key' in Numeric base class
    def key_prefix
      "currency"
    end

  end
end
