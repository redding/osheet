# this file is automatically required in when you require 'assert' in your tests

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

class Assert::Context

  def xstyle_markup(xworkbook)
    xworkbook.instance_variable_get("@__xmlss_undies_writer").flush.style_markup
  end

  def xelement_markup(xworkbook)
    xworkbook.instance_variable_get("@__xmlss_undies_writer").flush.element_markup
  end

  class << self


    def should_be_a_workbook_element(klass)
      should have_instance_methods :workbook, :styles, :templates

      should "be able to read the workbook and it's styles/templates" do
        wkbk = Osheet::Workbook.new {
          template(:column, :thing) {}
          template(:row, :empty) {}
          style('.title') {
            font 14
          }
          style('.title', '.header') {
            font :bold
          }
        }
        klass = klass.new(wkbk)

        assert_equal wkbk, klass.workbook
        assert_equal wkbk.styles, klass.styles
        assert_equal wkbk.templates, klass.templates
      end
    end

    def should_be_a_worksheet_element(klass)
      should have_instance_methods :worksheet, :columns

      should "be able to read the worksheet and it's columns" do
        wksht = Osheet::Worksheet.new {
          column {}
          column {}
          column {}
        }
        klass = klass.new(nil, wksht)

        assert_equal wksht, klass.worksheet
        assert_equal wksht.columns, klass.columns
      end
    end

    def should_be_a_styled_element(klass)
      should have_instance_methods :style_class

      should "default an empty style class" do
        default = klass.new
        assert_equal nil, default.send(:get_ivar, "style_class")
      end

      should "set a style class" do
        styled = klass.new{ style_class "awesome thing" }
        assert_equal "awesome thing", styled.send(:get_ivar, "style_class")
      end

      should "verify the style class string" do
        ['.thing', 'thing.thing', 'thing .thing > thing', 'thin>g'].each do |s|
          assert_raises ArgumentError do
            klass.new { style_class s }
          end
        end
        ['thing', '#thing 123', 'thing-one thing_one'].each do |s|
          assert_nothing_raised do
            klass.new { style_class s }
          end
        end
      end
    end

    def should_hm(klass, collection, item_klass)
      should have_reader collection
      should have_instance_method collection.to_s.sub(/s$/, '')

      should "should initialize #{collection} and add them to it's collection" do
        singular = collection.to_s.sub(/s$/, '')
        thing = klass.new do
          self.send(singular) {}
        end

        items = thing.send(:get_ivar, collection)
        assert_equal items, thing.send(collection)
        assert !items.empty?
        assert_equal 1, items.size
        assert_kind_of item_klass, items.first
      end

    end

  end
end
