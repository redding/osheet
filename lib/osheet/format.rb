require 'osheet/format/general'
require 'osheet/format/number'
require 'osheet/format/currency'
require 'osheet/format/accounting'
require 'osheet/format/datetime'
require 'osheet/format/percentage'
require 'osheet/format/fraction'
require 'osheet/format/scientific'
require 'osheet/format/text'
require 'osheet/format/special'
require 'osheet/format/custom'

module Osheet
  module Format

    VALUES = [
      :general, :number, :currency, :accounting,
      :datetime, :percentage, :fraction, :scientific,
      :text, :special, :custom
    ]

    def self.new(type, *args)
      unless VALUES.include?(type.to_sym)
        raise ArgumentError, "'#{type.inspect}' is not a valid format type"
      end
      self.const_get(type.to_s.capitalize).new(*args)
    end

  end
end
