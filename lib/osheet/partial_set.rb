require 'osheet/partial'

module Osheet
  class PartialSet < ::Hash

    # this class is a Hash that behaves kinda like a set.  I want to
    #  push partials into the set using the '<<' operator, only allow
    #  Osheet::Partial objs to be pushed, and then be able to reference
    #  a particular partial using a key

    def initialize
      super
    end

    def <<(partial)
      if (key = verify(partial))
        push(key, partial)
      end
    end

    # return the named partial
    def get(name)
      lookup(key(name.to_s))
    end

    private

    def lookup(key)
      self[key]
    end

    # push the partial onto the key
    def push(key, partial)
      self[key] = partial
    end

    # verify the partial, init and return the key
    #  otherwise ArgumentError it up
    def verify(partial)
      unless partial.kind_of?(Partial)
        raise ArgumentError, 'you can only push Osheet::Partial objs to the partial set'
      end
      pkey = partial_key(partial)
      self[pkey] ||= nil
      pkey
    end

    def partial_key(partial)
      key(partial.name)
    end

    def key(name)
      name.to_s
    end

  end
end
