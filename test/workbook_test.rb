require "assert"
require 'test/fixtures/mixins'
require 'test/fixtures/test_writer'

require 'osheet/workbook'

module Osheet

  class WorkbookTests < Assert::Context
    desc "a Workbook"
    before do
      @wkbk = Workbook.new
      @test_writer = TestWriter.new
    end
    subject { @wkbk }

    should have_instance_methods :writer, :element_stack, :workbook_element
    should have_instance_methods :workbook, :worksheets, :columns, :rows, :cells

    should have_instance_methods :use, :add, :template, :partial

    should have_instance_methods :styles, :style
    should have_instance_methods :align, :font, :bg, :border
    should have_instance_methods :border_left, :border_top
    should have_instance_methods :border_right, :border_bottom

    should have_instance_methods :worksheet, :column, :row, :cell
    should have_instance_methods :title, :meta, :style_class, :name
    should have_instance_methods :width, :height
    should have_instance_methods :autofit, :autofit?, :hidden, :hidden?
    should have_instance_methods :data, :format, :href, :formula
    should have_instance_methods :index, :rowspan, :colspan

    should "set it's defaults" do
      assert_equal nil, subject.workbook.title

      assert_equal WorkbookElement.new, subject.workbook_element
      assert_equal subject.workbook_element, subject.workbook

      assert_kind_of Workbook::ElementStack, subject.element_stack
      assert_equal 1, subject.element_stack.size
      assert_equal subject.workbook_element, subject.element_stack.current
    end

    should "set its title, casting it to a string" do
      wb = Workbook.new { title :fun }
      assert_equal "fun", wb.workbook.title
    end

  end

  class ElementStackTests < Assert::Context
    desc "an ElementStack"
    before { @s = Workbook::ElementStack.new }
    subject { @s }

    should "be an Array" do
      assert_kind_of ::Array, subject
    end

    should have_instance_method :push, :pop, :current, :size, :using

    should "push objects onto the stack" do
      assert_nothing_raised do
        subject.push("something")
        subject.push("something else")
      end

      assert_equal 2, subject.size
    end

    should "push objects onto the stack for the duration of a block" do
      subject.push("something")

      assert_equal "something", subject.current
      subject.using("using") do
        assert_equal "using", subject.current
      end
      assert_equal "something", subject.current
    end

    should "fetch the last item in the array with the current method" do
      subject.push("something")
      subject.push("something else")

      assert_equal "something else", subject.current
    end

    should "remove the last item in the array with the pop method" do
      subject.push("something")
      subject.push("something else")

      assert_equal 2, subject.size

      item = subject.pop
      assert_equal "something else", item
      assert_equal 1, subject.size
    end

    should "return nil if trying to pop on an empty stack" do
      assert_equal 0, subject.size

      assert_nothing_raised do
        subject.pop
      end

      assert_nil subject.pop
    end

  end

  class WorkbookStyleTests < WorkbookTests
    desc "that defines styles"
    before do
      @wkbk = Workbook.new(@test_writer) {
        style('.test')
        style('.test.awesome')
      }
    end

    should "return the style obj created" do
      style = subject.style(".a.test.style")

      assert_kind_of Style, style
      assert_equal '.a.test.style', style.selectors.first
    end

    should "return the last style added if called with no args" do
      assert_equal subject.styles.last, subject.style
    end

    should "add them to it's styles" do
      assert_equal 2, subject.styles.size
      assert_equal 1, subject.styles.first.selectors.size
      assert_equal '.test', subject.styles.first.selectors.first
      assert_equal 1, subject.styles.last.selectors.size
      assert_equal '.test.awesome', subject.styles.last.selectors.first
    end

    should "call the writer with the created style obj" do
      assert_equal subject.styles.last, subject.writer.styles.last
    end

  end

  class WorkbookWorksheetTests < WorkbookTests
    desc "with worksheets"
    before do
      @wkbk = Workbook.new(@test_writer) {
        worksheet {
          name "one"
        }
        worksheet {
          name "two"
          meta :some_meta
        }
      }
    end

    should "return the worksheet obj created" do
      assert_kind_of Worksheet, subject.worksheet("test")
    end

    should "add them to it's worksheets reader" do
      assert_equal 2, subject.worksheets.size
      assert_equal "one", subject.worksheets.first.name
      assert_equal "two", subject.worksheets.last.name
      assert_equal :some_meta, subject.worksheets.last.meta
    end

    should "return the last worksheet added if called with no args" do
      assert_equal subject.worksheets.last, subject.worksheet
    end

    should "call the writer with the created worksheet obj" do
      assert_equal subject.worksheets.last, subject.writer.worksheets.last
    end

    # TODO: the writer should validate this
    # should "not allow multiple worksheets with the same name" do
    #   assert_raises ArgumentError do
    #     Workbook.new {
    #       worksheet { name "awesome" }
    #       worksheet { name "awesome" }
    #     }
    #   end
    #   assert_nothing_raised do
    #     Workbook.new {
    #       worksheet { name "awesome" }
    #       worksheet { name "awesome1" }
    #     }
    #   end
    # end

  end

  class WorkbookColumnTests < WorkbookTests
    desc "with columns"
    before do
      @wkbk = Workbook.new(@test_writer) {
        worksheet {
          column
          column(124)
        }
      }
    end

    should "add them to it's columns reader" do
      assert_equal 2, subject.columns.size
      assert_equal nil, subject.columns.first.width
      assert_equal 124, subject.columns.last.width
    end

    should "call the writer with the created column obj" do
      assert_equal subject.columns.last, subject.writer.columns.last
    end

  end


  class WorkbookRowCellMetaTests < WorkbookTests
    desc "with columns, meta, rows, and cells"
    before do
      @wkbk = Workbook.new(@test_writer) {
        worksheet {
          column(100) { meta(:label => 'One') }
          column { meta(:label => 'Two') }

          row {
            columns.each do |column|
              cell(column.meta[:label])
            end
          }
          row(120) {
            cell {
              data 12234
              format :currency
            }
            cell(Time.now) {
              format :datetime, 'mm/dd/yyyy'
            }

          }
        }
      }
    end

    should "add the columns to it's columns reader" do
      assert_equal 2, subject.columns.size
      assert_equal 100, subject.columns.first.width
      assert_equal nil, subject.columns.last.width

      assert_equal subject.columns.last, subject.writer.columns.last
    end

    should "just keep the last row in its rows reader" do
      assert_equal 1, subject.rows.size
      assert_equal 120, subject.rows.first.height

      assert_equal 2, subject.writer.rows.size
      assert_equal subject.rows.first, subject.writer.rows.last
    end

    should "access the cells of its last row" do
      assert_equal 2, subject.cells.size
      assert_equal 12234, subject.cells.first.data

      assert_equal 4, subject.writer.cells.size
      assert_equal subject.cells.last, subject.writer.rows.last.cells.last
    end

  end

  class WorkbookStyleTests < WorkbookTests
    desc "that defines and uses styles"
    before do
      skip
    end

    should "work"
  end


  class WorkbookPartialTests < WorkbookTests
    desc "that defines partials"
    before do
      skip
      @wkbk = Workbook.new {
        partial(:named_styles) { |name|
          style(".#{name}")
          style(".#{name}.awesome")
        }
        partial(:stuff) {}
      }
    end

    should "add them to it's partials" do
      assert_equal 2, subject.partials.keys.size
      assert subject.partials.has_key?('named_styles')
      assert subject.partials.has_key?('stuff')
      assert_kind_of Partial, subject.partials.get('stuff')
    end

    should "add it's partials to it's markup" do
      subject.add(:named_styles, 'test')
      assert_equal 2, subject.styles.size
      assert_equal '.test', subject.styles.first.selectors.first
      assert_equal '.test.awesome', subject.styles.last.selectors.first
    end

  end

  class WorkbookTemplateTests < WorkbookTests
    desc "that defines templates"
    before do
      skip
      @wkbk = Workbook.new {
        template(:column, :yo) { |color|
          width 200
          meta(:color => color)
        }
        template(:row, :yo_yo) {
          height 500
        }
        template(:worksheet, :go) {
          column(:yo, 'blue')
          row(:yo_yo)
        }
      }
    end

    should "add them to it's templates" do
      assert subject.templates
      assert_kind_of TemplateSet, subject.templates
      assert_equal 3, subject.templates.keys.size
      assert_kind_of Template, subject.templates.get('column', 'yo')
      assert_kind_of Template, subject.templates.get('row', 'yo_yo')
      assert_kind_of Template, subject.templates.get('worksheet', 'go')
    end

    should "apply it's templates" do
      subject.worksheet(:go)
      assert_equal 1, subject.worksheets.size
      assert_equal 'blue', subject.worksheets.first.columns.first.meta[:color]
      assert_equal 500, subject.worksheets.first.rows.first.attributes[:height]
    end

  end

  class WorkbookMixinTests < WorkbookTests
    desc "with mixins"
    before do
      skip
      @wkbk = Workbook.new {
        use StyledMixin
        use TemplatedMixin
      }
    end

    should "add the mixin styles to it's styles" do
      assert_equal 2, subject.styles.size
      assert_equal 1, subject.styles.first.selectors.size
      assert_equal '.test', subject.styles.first.selectors.first
      assert_equal 1, subject.styles.last.selectors.size
      assert_equal '.test.awesome', subject.styles.last.selectors.first
    end

    should "add the mixin templates to it's templates" do
      assert subject.templates
      assert_kind_of TemplateSet, subject.templates
      assert_equal 3, subject.templates.keys.size
      assert_kind_of Template, subject.templates.get('column', 'yo')
      assert_kind_of Template, subject.templates.get('row', 'yo_yo')
      assert_kind_of Template, subject.templates.get('worksheet', 'go')

      subject.worksheet(:go)
      assert_equal 1, subject.worksheets.size
      assert_equal 'blue', subject.worksheets.first.columns.first.meta[:color]
      assert_equal 500, subject.worksheets.first.rows.first.attributes[:height]
    end

  end

  # class WorkbookWriterTests < WorkbookTests
  #   desc "with a writer"
  #   before do
  #     skip
  #     @wkbk = Workbook.new {
  #       style('.test')
  #       style('.test.awesome')
  #     }
  #   end

  #   should have_instance_method :writer, :to_data, :to_file

  #   should "provide a writer for itself" do
  #     writer = subject.writer
  #     assert writer
  #     assert_kind_of XmlssWriter::Base, writer
  #   end

  # end

end
