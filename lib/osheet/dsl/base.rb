module Osheet
  class Base
    
    ATTRS = [:class, :style]
    ATTRS.each {|a| attr_accessor a}

    class << self
      
      def configure(*args, &block)
        it = new(*args)
        block.call(it) if block
        it
      end
      
      def has(things)
        things.each do |collection, item|
          clean_collection = cleanup_name(collection)
          clean_item = cleanup_name(item)
          
          define_method(clean_collection) do
            fetch_value(clean_collection, [])
          end
          
          define_method(clean_item.downcase) do |*arge, &block|
            fetch_collection(clean_collection, []) << \
            osheet_constantize("Osheet::#{clean_item}").configure(*args, &block)
          end
        end
      end
      
      def needs(thing)
        clean_need = cleanup_name(thing)

        define_method(clean_need) do
          fetch_value(clean_need)
        end        
      end
      
    end
    
    def initialize(args={})
      set_args ATTRS, args
    end
    
    protected
    
    class << self
      
      def cleanup_name(name)
        name.to_s.gsub(/\W/,'')
      end
      
      def fetch_value(clean_name, default_value=nil)
        instance_variable_get("@#{clean_name}") ||
        instance_variable_set("@#{clean_name}", default_value)
      end

    end
    
    def set_args(arg_list, args)
      if args && args.kind_of?(::Hash)
        arg_list.each {|a| instance_variable_set("@#{a}", args[a])}
      end
    end
    
    private
    
    if Module.method(:const_get).arity == 1
      def osheet_constantize(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = ::Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end unless ::String.respond_to?('constantize')
    else
      # Ruby 1.9 introduces an inherit argument for Module#const_get and
      # #const_defined? and changes their default behavior.
      def osheet_constantize(camel_cased_word) #:nodoc:
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = ::Object
        names.each do |name|
          constant = constant.const_get(name, false) || constant.const_missing(name)
        end
        constant
      end unless ::String.respond_to?('constantize')
    end    
    
  end
end
