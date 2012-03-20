# this file is automatically required in when you require 'assert' in your tests

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

class Assert::Context

  # Macros

  def self.be_a_meta_element(*args)
    called_from = caller.first
    macro_name =  "be a meta element"

    Assert::Macro.new(macro_name) do
      should have_instance_method :meta, [called_from]

      should "default an empty meta value", called_from do
        assert_equal nil, subject.class.new.meta
      end

      should "set meta info", called_from do
        meta_elem = subject.class.new

        meta_elem.meta({:key => "value"})
        assert_equal({:key => "value"}, meta_elem.meta)
      end
    end
  end

  def self.be_a_styled_element(*args)
    called_from = caller.first
    macro_name =  "be a styled element"

    Assert::Macro.new(macro_name) do
      should have_instance_method :style_class, [called_from]

      should "default an empty style class", called_from do
        assert_equal nil, subject.class.new.style_class
      end

      should "set a style class", called_from do
        styled = subject.class.new
        styled.style_class("awesome thing")
        assert_equal "awesome thing", styled.style_class
      end

      should "validate the style class string", called_from do
        ['.thing', 'thing.thing', 'thing .thing > thing', 'thin>g'].each do |s|
          assert_raises ArgumentError do
            subject.class.new.style_class(s)
          end
        end

        ['thing', '#thing 123', 'thing-one thing_one'].each do |s|
          assert_nothing_raised do
            subject.class.new.style_class(s)
          end
        end
      end

    end
  end

end
