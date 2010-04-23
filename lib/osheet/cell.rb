require 'osheet/base'

module Osheet
  class Cell < Osheet::Base

    attr_accessor :data

    ATTRS = [:format, :rowspan, :colspan]
    ATTRS.each {|a| attr_accessor a}

    def initialize(data='', args={})
      @data = data
      set_args ATTRS, args
      super(args)
    end
    
  end
end
