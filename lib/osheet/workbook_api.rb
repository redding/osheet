module Osheet; end
module Osheet::WorkbookApi

  # reference API

  [ :templates,
    :partials,
    :styles
  ].each do |meth|
    define_method(meth) do |*args|
      workbook.send(meth, *args)
    end
  end

  def worksheets
    workbook.worksheets
  end

  def columns
    worksheets.last.columns
  end

  def rows
    worksheets.last.rows
  end

  def cells
    rows.last.cells
  end

  # markup handling API

  def template(*args, &build)
    Osheet::Template.new(*args, &build).tap do |template|
      element_stack.current.template(template)
    end
  end

  def partial(*args, &build)
    Osheet::Partial.new(*args, &build).tap do |partial|
      element_stack.current.partial(partial)
    end
  end

  class StyleBuild

    def initialize(scope, *args, &build)
      @scope = scope
      @style = Osheet::Style.new(*args, &build)
    end

    def add
      @scope.element_stack.current.style(@style)
      if block_given?
        @scope.element_stack.using(@style) { yield @style.build }
      end
    end
  end

  def style(*args, &build)
    StyleBuild.new(self, *args, &build).add do |build|
      build.call
    end
  end

  # element handling API

  class TemplatedElement

    # this class is used to create elements that can be templated.
    # Arguments are handled differently if building an element from
    # a template vs. building from a build block.
    # After the element is built, it is added to the current stack element
    # and either the build or writer is called.

    ELEMENT_CLASS = {
      :worksheet => Osheet::Worksheet,
      :column    => Osheet::Column,
      :row       => Osheet::Row,
      :cell      => Osheet::Cell
    }

    def initialize(scope, name, *args, &build)
      @scope = scope
      @workbook = @scope.workbook
      @name = name
      @args = args
      if (@template = @workbook.templates.get(@name, @args.first))
        @element = ELEMENT_CLASS[@name].new
        @build   = Proc.new { @scope.instance_exec(*@args[1..-1], &@template) }
      else
        @element = ELEMENT_CLASS[@name].new(*@args)
        @build   = build || Proc.new {}
      end
    end

    def add
      @scope.element_stack.current.send(@name, @element)
      @scope.element_stack.using(@element) do
        if @scope.writer
          @scope.writer.send(@name, @element, &@build)
        else
          @build.call
        end
      end
    end

  end

  # used on: workbook
  def worksheet(*args, &block)
    if args.empty? && block.nil?
      worksheets.last
    else
      TemplatedElement.new(self, :worksheet, *args, &block).add
    end
  end

  # used on: worksheet
  def column(*args, &block)
    TemplatedElement.new(self, :column, *args, &block).add
  end

  # used on: worksheet
  def row(*args, &block)
    if args.empty? && block.nil?
      rows.last
    else
      TemplatedElement.new(self, :row, *args, &block).add
    end
  end

  # used on: row
  def cell(*args, &block)
    if args.empty? && block.nil?
      cells.last
    else
      TemplatedElement.new(self, :cell, *args, &block).add
    end
  end

  # style attribute API

  Osheet::Style::SETTINGS.each do |setting|
    define_method(setting) do |*args|
      element_stack.current.send(setting, *args)
    end
  end

  def border(*args)
    element_stack.current.border(*args)
  end

  # element attribute API

  [ :title,       # workbook_element
    :name,        # worksheet
    :meta,        # worksheet, column, row, cell
    :style_class, # column, row, cell
    :width,       # column
    :height,      # row
    :autofit,     # column, row
    :autofit?,    # column, row
    :hidden,      # column, row
    :hidden?,     # column, row
    :data,        # cell
    :format,      # cell
    :href,        # cell
    :formula,     # cell
    :index,       # cell
    :rowspan,     # cell
    :colspan,     # cell
  ].each do |meth|
    define_method(meth) do |*args|
      element_stack.current.send(meth, *args)  # for self referencing
      if self.writer                           # for writing
        self.writer.send(meth, *args)
      end
    end
  end

end
