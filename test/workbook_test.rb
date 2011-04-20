require "test/helper"
require 'osheet/workbook'
require 'test/mixins'

module Osheet

  class WorkbookTest < Test::Unit::TestCase

    context "Osheet::Workbook" do
      subject do
        Workbook.new
      end

      should_have_readers :styles, :templates, :partials
      should_have_instance_methods :title, :attributes, :use, :add
      should_have_instance_methods :style, :template, :partial

      should_hm(Workbook, :worksheets, Worksheet)

      should "set it's defaults" do
        assert_equal nil, subject.send(:get_ivar, "title")
        assert_equal [], subject.worksheets
        assert_equal StyleSet.new, subject.styles
        assert_equal TemplateSet.new, subject.templates
        assert_equal PartialSet.new, subject.partials
      end

      should "know it's attribute(s)" do
        subject.send(:title, "The Poo")
        [:title].each do |a|
          assert subject.attributes.has_key?(a)
        end
        assert_equal "The Poo", subject.attributes[:title]
      end

    end
  end

  class WorkbookTitleTest < Test::Unit::TestCase
    context "A workbook with a title" do
      subject do
        Workbook.new { title "The Poo" }
      end

      should "know it's title" do
        assert_equal "The Poo", subject.title
      end

      should "set it's title" do
        subject.title(false)
        assert_equal false, subject.title
        subject.title('la')
        assert_equal 'la', subject.title
        subject.title(nil)
        assert_equal 'la', subject.title
      end

    end
  end

  class WorkbookWorksheetsTest < Test::Unit::TestCase
    context "A workbook with worksheets" do
      subject do
        Workbook.new {
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
  end

  class WorkbookStyleTest < Test::Unit::TestCase
    context "A workbook that defines styles" do
      subject do
        Workbook.new {
          style('.test')
          style('.test.awesome')
        }
      end

      should "add them to it's styles" do
        assert_equal 2, subject.styles.size
        assert_equal 1, subject.styles.first.selectors.size
        assert_equal '.test', subject.styles.first.selectors.first
        assert_equal 1, subject.styles.last.selectors.size
        assert_equal '.test.awesome', subject.styles.last.selectors.first
      end

    end
  end

  class WorkbookPartialTest < Test::Unit::TestCase
    context "A workbook that defines partials" do
      subject do
        Workbook.new {
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
  end

  class WorkbookTemplateTest < Test::Unit::TestCase
    context "A workbook that defines templates" do
      subject do
        Workbook.new {
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
  end

  class WorkbookBindingTest < Test::Unit::TestCase
    context "a workbook defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 'test'
        @workbook = Workbook.new { title @test }

        assert !@workbook.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @workbook.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @workbook.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @workbook.attributes[:title]
        assert_equal @test.object_id, @workbook.attributes[:title].object_id
      end

    end
  end

  class WorkbookMixins < Test::Unit::TestCase
    context "a workbook w/ mixins" do
      subject do
        Workbook.new {
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
  end

  class WorkbookWriter < Test::Unit::TestCase
    context "a workbook" do
      subject do
        Workbook.new {
          style('.test')
          style('.test.awesome')
        }
      end

      should_have_instance_method :writer, :to_data, :to_file

      should "provide a writer for itself" do
        writer = subject.writer
        assert writer
        assert_kind_of XmlssWriter::Base, writer
      end

    end
  end

end
