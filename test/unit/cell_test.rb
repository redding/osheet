require "#{File.dirname(__FILE__)}/../test_helper"

class Osheet::CellTest < Test::Unit::TestCase

  context "Osheet::Cell" do
    subject { Osheet::Cell.new }

    should_have_instance_methods :data, :format, :colspan, :rowspan
    
    should "default it's data to ''" do
      assert_equal '', subject.data
    end
    
    # TODO: text format as default?
    should "default it's format to nil" do
      assert subject.format.nil?
    end
    
    should "default it's rowspan to 1" do
      assert 1, subject.rowspan
    end
    
    should "default it's colspan to 1" do
      assert 1, subject.colspan
    end
    
    context "that has attributes" do
      subject do
        Osheet::Cell.new "More Poo", {
          :format => :text,
          :colspan => 4,
          :rowspan => 2
        }
      end

      should "should know it's attributes" do
        assert_equal "More Poo", subject.data
        assert_equal :text, subject.format
        assert_equal 4, subject.colspan
        assert_equal 2, subject.rowspan
      end
    end    
    
  end

end
