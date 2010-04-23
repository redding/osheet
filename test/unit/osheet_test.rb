require "#{File.dirname(__FILE__)}/../test_helper"

class OsheetTest < Test::Unit::TestCase

  context "Osheet" do

    should "use Excel" do
      assert_equal "application/vnd.ms-excel", Osheet::MIME_TYPE
      assert_equal "Excel", Osheet::SPREADSHEET_TYPE
    end
    
  end

end
