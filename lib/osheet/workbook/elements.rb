module Osheet; end
class Osheet::Workbook; end

module Osheet::Workbook::Elements

  # markup handling API

  def template(*args, &block)
    Template.new(*args, &block).tap do |template|
      object_stack.current.template(template)
    end
  end

  def partial(*args, &block)
    Partial.new(*args, &block).tap do |partial|
      object_stack.current.partial(partial)
    end
  end

  def use(mixin)
    (mixin.templates || []).each{ |t| templates(t) }
    (mixin.partials  || []).each{ |p| partials(p)  }
    (mixin.styles    || []).each{ |s| styles(s)    }
  end

  def add(partial_name, *args)
    workbook.partials.get(partial_name).tap do |p|
      instance_exec(*args, &p) if p
    end
  end


  # element handling API

  # used on: workbook
  def worksheet(*args, &block)
    if args.empty? && block.nil?
      worksheets.last
    else
      # TODO: the writer needs to verify not writing sheet w/ conflicting name
      Osheet::Worksheet.new(*args).tap do |worksheet|
        element_stack.current.worksheet(worksheet)
        element_stack.using(worksheet) do
          writer ? writer.worksheet(worksheet, &block) : block.call
        end
      end
    end
  end

  # used on: worksheet
  def column(*args, &block)
    Osheet::Column.new(*args).tap do |column|
      element_stack.current.column(column)
      element_stack.using(column) do
        writer ? writer.column(column, &block) : block.call
      end
    end
  end

  # used on: worksheet
  def row(*args, &block)
    if args.empty? && block.nil?
      rows.last
    else
      Osheet::Row.new(*args).tap do |row|
        element_stack.current.row(row)
        element_stack.using(row) do
          writer ? writer.row(row, &block) : block.call
        end
      end
    end
  end

  # used on: row
  def cell(*args, &block)
    if args.empty? && block.nil?
      cells.last
    else
      Osheet::Cell.new(*args).tap do |cell|
        element_stack.current.cell(cell)
        element_stack.using(cell) do
          writer ? writer.cell(cell, &block) : block.call
        end
      end
    end
  end


  # element attribute reference API

  # used on: workbook_element
  def title(*args)
    element_stack.current.title(*args)
  end

  # used on: worksheet
  def name(*args)
    element_stack.current.name(*args)
  end

  # used on: :worksheet, column, row, cell
  def meta(*args)
    element_stack.current.meta(*args)
  end

  # TODO: set the args on the current_obj
  # - hook up with the writer
  # used on: column, row, cell
  def style_class
  end

  # used on: column
  def width(*args)
    element_stack.current.width(*args)
  end

  # used on: row
  def height(*args)
    element_stack.current.height(*args)
  end

  # used on: column, row
  def autofit(*args)
    element_stack.current.autofit(*args)
  end

  # used on: column, row
  def autofit?(*args)
    element_stack.current.autofit?(*args)
  end

  # used on: column, row
  def hidden(*args)
    element_stack.current.hidden(*args)
  end

  # used on: column, row
  def hidden?(*args)
    element_stack.current.hidden?(*args)
  end

  # used on: cell
  def data(*args)
    element_stack.current.data(*args)
  end

  # used on: cell
  def format(*args)
    element_stack.current.format(*args)
  end

  # used on: cell
  def href(*args)
    element_stack.current.href(*args)
  end

  # used on: cell
  def formula(*args)
    element_stack.current.formula(*args)
  end

  # used on: cell
  def index(*args)
    element_stack.current.index(*args)
  end

  # used on: cell
  def rowspan(*args)
    element_stack.current.rowspan(*args)
  end

  # used on: cell
  def colspan(*args)
    element_stack.current.colspan(*args)
  end

end
