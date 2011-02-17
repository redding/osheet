require "test/helper"

class Osheet::WorkbookTest < Test::Unit::TestCase

  context "Osheet::Workbook" do

    should_have_instance_methods :worksheets, :worksheet

  end

end
