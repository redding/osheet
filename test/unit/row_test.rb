require "#{File.dirname(__FILE__)}/../test_helper"

class Osheet::RowTest < Test::Unit::TestCase

  context "Osheet::Row" do
    subject { Osheet::Row.new }
    
    should "initialize" do
      assert subject
    end
    
    should_have_instance_methods :cells, :cell
    
  end

end
