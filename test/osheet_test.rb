require "test/helper"

class OsheetTest < Test::Unit::TestCase

  context "Osheet" do
    subject {::Osheet}

    should_have_instance_method :register

    should "use provide a default mime type" do
      assert_equal "application/vnd.ms-excel", Osheet::MIME_TYPE
    end

  end

end
