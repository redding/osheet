require 'osheet/template'
require 'osheet/workbook/partial_set'

module Osheet; end
class Osheet::Workbook; end

module Osheet
  class Workbook::TemplateSet < Workbook::PartialSet

    # this class is a PartialSet that keys off of the template element
    # and name.  Only Osheet::Template objs can be pushed, and you reference
    # a particular template by its element and name

    def initialize
      super
    end

    # return the template set for the named element
    def get(element, name)
      lookup(key(element.to_s, name.to_s))
    end

    private

    def lookup(key)
      self[key.first][key.last] if self[key.first]
    end

    # push the template onto the key
    def push(key, template)
      self[key.first][key.last] = template
    end

    # verify the template, init the key set, and return the key string
    #  otherwise ArgumentError it up
    def verify(template)
      unless template.kind_of?(Template)
        raise ArgumentError, 'you can only push Osheet::Template objs to the template set'
      end
      key = template_key(template)
      self[key.first] ||= {}
      self[key.first][key.last] ||= nil
      key
    end

    def template_key(template)
      key(template.element, template.name)
    end

    def key(element, name)
      [element.to_s, name.to_s]
    end
  end
end
