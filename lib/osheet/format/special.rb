require 'enumeration'

module Osheet::Format

  class Special
    include Enumeration

    enum(:type, {
      :zip_code => '00000',
      :zip_code_plus_4 => '00000-0000',
      :phone_number => '[<=9999999]###-####;(###) ###-####',
      :social_security_number => '000-00-0000'
    })

    def initialize(opts={})
      self.type = opts[:type]
    end

    def style
      type
    end

    def key
      "special_#{type_key.to_s.gsub('_', '')}"
    end

  end
end
