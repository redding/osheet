require "assert"
require 'test/fixtures/mixins'
require 'test/fixtures/test_writer'

require 'osheet/workbook'

module Osheet

  class WorkbookTests < Assert::Context
    desc "Osheet::Workbook"
    before do
      @wkbk = Workbook.new
      @test_writer = TestWriter.new
    end
    subject { @wkbk }

    should have_instance_methods :meta, :use, :add
    should have_instance_methods :templates, :template
    should have_instance_methods :partials, :partial
    should have_instance_method  :writer

    should have_instance_methods :styles, :style
    should have_instance_methods :align, :font, :bg, :border
    should have_instance_methods :border_left, :border_top
    should have_instance_methods :border_right, :border_bottom

    should have_instance_method  :workbook
    should have_instance_methods :worksheets, :worksheet

    should "set it's defaults" do
      assert_equal Workbook::TemplateSet.new,  subject.templates
      assert_equal Workbook::PartialSet.new,   subject.partials
      assert_equal Workbook::StyleSet.new,     subject.styles
      assert_equal Workbook::WorksheetSet.new, subject.worksheets
    end

  end

  class WorkbookStyleTests < WorkbookTests
    desc "A workbook that defines styles"
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

  class WorkbookWorksheetsTests < WorkbookTests
    desc "A workbook with worksheets"
    before do
      skip
      @wkbk = Workbook.new {
        worksheet {
          name "Poo!"
          column
          row {
            cell {
              format  :number
              data    1
            }
          }
        }
      }
    end

    should "set it's worksheets" do
      assert_equal 1, subject.worksheets.size
      assert_kind_of Worksheet, subject.worksheets.first
    end

    should "not allow multiple worksheets with the same name" do
      assert_raises ArgumentError do
        Workbook.new {
          worksheet { name "awesome" }
          worksheet { name "awesome" }
        }
      end
      assert_nothing_raised do
        Workbook.new {
          worksheet { name "awesome" }
          worksheet { name "awesome1" }
        }
      end
    end

  end

  class WorkbookPartialTests < WorkbookTests
    desc "A workbook that defines partials"
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
    desc "A workbook that defines templates"
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
    desc "a workbook w/ mixins"
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

  class WorkbookWriterTests < WorkbookTests
    desc "a workbook"
    before do
      skip
      @wkbk = Workbook.new {
        style('.test')
        style('.test.awesome')
      }
    end

    should have_instance_method :writer, :to_data, :to_file

    should "provide a writer for itself" do
      writer = subject.writer
      assert writer
      assert_kind_of XmlssWriter::Base, writer
    end

  end

end
