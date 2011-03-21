module Osheet::Associations

  def self.included(receiver)
    receiver.send(:extend, ClassMethods)
  end

  module ClassMethods

    # A has many esque association helper
    #  - will provide a collection reader
    #  - will define a 'singular' item method for adding to the collection
    #  - will support adding to the collection both by black and template
    def hm(collection)
      unless collection.to_s =~ /s$/
        raise ArgumentError, "association item names must end in 's'"
      end
      plural = collection.to_s
      singular = plural.to_s.sub(/s$/, '')
      klass = Osheet.const_get(singular.capitalize)

      # define collection reader
      self.send(:define_method, plural, Proc.new do
        if instance_variable_get("@#{plural}").nil?
          instance_variable_set("@#{plural}", [])
        end
        instance_variable_get("@#{plural}")
      end)

      # define collection item writer
      self.send(:define_method, singular) do |*args, &block|
        if instance_variable_get("@#{plural}").nil?
          instance_variable_set("@#{plural}", [])
        end
        if block
          # add by block
          instance_variable_get("@#{plural}") << klass.new(&block)
        else
          # TODO: add by template
        end
      end

    end

  end

end
