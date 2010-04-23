require "#{File.dirname(__FILE__)}/../test_helper"

class Osheet::ColumnTest < Test::Unit::TestCase

  context "Osheet::Column" do
    subject { Osheet::Column.new }
    
    should "initialize" do
      assert subject
    end
  end

end
