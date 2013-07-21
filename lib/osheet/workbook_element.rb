require 'osheet/style'
require 'osheet/worksheet'

module Osheet

  class WorkbookElement

    # This 'WorkbookElement' class handles all workbook state.  It is setup
    # and referenced by the 'Workbook' class when it runs builds

    class PartialSet < ::Hash; end
    class TemplateSet < PartialSet; end
    class StyleSet < ::Array; end
    class WorksheetSet < ::Array; end

    attr_reader :title
    attr_reader :templates, :partials, :styles, :worksheets

    def initialize
      @title = nil

      @templates  = TemplateSet.new
      @partials   = PartialSet.new
      @styles     = StyleSet.new
      @worksheets = WorksheetSet.new
    end

    def title(value=nil)
      value.nil? ? @title : @title = value.to_s
    end

    def template(template)
      @templates << template
    end

    def partial(partial)
      @partials << partial
    end

    def style(style)
      @styles << style
    end

    def worksheet(worksheet)
      @worksheets << worksheet
    end

    def styles(*args)
      @styles.for(*args)
    end

    def ==(other)
      title == other.title &&
      templates == other.templates &&
      partials == other.partials &&
      styles == other.styles &&
      worksheets == other.worksheets
    end

  end

  class WorkbookElement::PartialSet

    # this class is a Hash that behaves kinda like a set.  I want to
    # push partials into the set using the '<<' operator, only allow
    # Osheet::Partial objs to be pushed, and then be able to reference
    # a particular partial using its name

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
      key(partial.instance_variable_get("@name"))
    end

    def key(name)
      name.to_s
    end

  end

  class WorkbookElement::TemplateSet < WorkbookElement::PartialSet

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
      key(template.instance_variable_get("@element"), template.instance_variable_get("@name"))
    end

    def key(element, name)
      [element.to_s, name.to_s]
    end

  end

  class WorkbookElement::StyleSet < ::Array

    # this class is an Array with some helper methods.  I want to
    # push styles into the set using the '<<' operator, only allow
    # Osheet::Style objs to be pushed, and then be able to reference
    # a particular set of styles using a style class.

    def initialize
      super
    end

    def <<(value)
      super if verify(value)
    end

    # return the style set for the style class
    def for(style_class=nil)
      style_class.nil? ? self : self.select{|s| s.match?(style_class)}
    end

    private

    # verify the style, otherwise ArgumentError it up
    def verify(style)
      if style.kind_of?(Style)
        true
      else
        raise ArgumentError, 'you can only push Osheet::Style objs to the style set'
      end
    end

  end

  class WorkbookElement::WorksheetSet < ::Array

    # this class is just a wrapper to Array.  I want to push worksheets
    # into the set using the '<<' operator, but only allow Worksheet objs
    # to be pushed.

    def initialize
      super
    end

    def <<(value)
      super if verify(value)
    end

    private

    # verify the worksheet, otherwise ArgumentError it up
    def verify(worksheet)
      if worksheet.kind_of?(Worksheet)
        true
      else
        raise ArgumentError, 'can only push Osheet::Worksheet to the set'
      end
    end

  end

end
