require 'osheet/column'
require 'osheet/row'

module Osheet
  class Worksheet
    include Associations
    include WorkbookElement
    include MetaElement

    hm :columns
    hm :rows

    def initialize(workbook=nil, *args, &block)
      @workbook = workbook
      @name = nil
      instance_exec(*args, &block) if block_given?
    end

    def name(value=nil)
      !value.nil? ? @name = sanitized_name(value) : @name
    end

    def attributes
      { :name => @name }
    end

    private

    def sanitized_name(name_value)
      if @workbook && @workbook.worksheets.collect{|ws| ws.name}.include?(name_value)
        raise ArgumentError, "the sheet name '#{name_value}' is already in use.  choose a sheet name that is not used by another sheet"
      end
      name_value
    end

  end
end
