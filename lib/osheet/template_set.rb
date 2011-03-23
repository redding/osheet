require 'osheet/template'

module Osheet
  class TemplateSet < ::Hash

    # this class is a Hash that behaves kinda like a set.  I want to
    #  push templates into the set using the '<<' operator, only allow
    #  Osheet::Template objs to be pushed, and then be able to reference
    #  a particular set of templates using a key

    def initialize
      super
    end

    def <<(template)
      if (key = verify(template))
        push(key, template)
      end
    end

    # return the template set for the named element
    def for(element, name)
      lookup(key(element.to_s, name.to_s))
    end

    private

    def lookup(key)
      self[key.first][key.last]
    end

    # push the template onto the key set
    def push(key, template)
      self[key.first][key.last] << template
    end

    # verify the template, init the key set, and return the key string
    #  otherwise ArgumentError it up
    def verify(template)
      unless template.kind_of?(Template)
        raise ArgumentError, 'you can only push Osheet::Template objs to the template set'
      end
      key = template_key(template)
      self[key.first] ||= {}
      self[key.first][key.last] ||= []
      key
    end

    def template_key(template)
      key(template.element, template.name)
    end

    def key(element, name)
      [element, name]
    end
  end
end
