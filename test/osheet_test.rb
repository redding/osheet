require "assert"

class OsheetTest < Assert::Context
  desc "Osheet"
  subject {::Osheet}

  should have_instance_method :register

  should "use provide a default mime type" do
    assert_equal "application/vnd.ms-excel", Osheet::MIME_TYPE
  end

end
