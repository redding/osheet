require 'osheet/format/general'
require 'osheet/format/number'

module Osheet::Format

  VALUES = [
    :general,:number, :currency, :accounting,
    :date, :time, :percentage, :fraction, :scientific,
    :text, :special, :custom
  ]

  class << self
    def new(type, opts={})
      unless VALUES.include?(type)
        raise ArgumentError, "'#{type.inspect}' is not a valid format type"
      end
      self.const_get(type.to_s.capitalize).new(opts)
    end
  end

end
