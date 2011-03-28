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
        if !args.empty?#self.respond_to?(:workbook) && self.workbook && (tmpl = self.workbook.template(singular, args.first))
          #tmpl.block.call(*args[1..-1])
        else
          # add by block
          instance_variable_get("@#{plural}") << if self.respond_to?(:workbook)
            # on: worksheet, column, row
            # creating: column, row, cell
            klass.new(self.workbook, self, &block)
          else
            # on: workbook
            # creating: worksheet
            klass.new(self, &block)
          end
        end
      end

    end

  end

end
