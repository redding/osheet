require "assert"
require 'osheet/format/datetime'

class Osheet::Format::Datetime

  class UnitTests < Assert::Context
    desc "Osheet::Format::Datetime format"

    should "generate a basic style string and key" do
      f = Osheet::Format::Datetime.new 'mm/dd/yyyy'
      assert_equal "mm/dd/yyyy", f.style
      assert_equal "datetime_mm/dd/yyyy", f.key
    end

    should "generate a more complex style string and key" do
      f = Osheet::Format::Datetime.new 'yy-m'
      assert_equal 'yy-m', f.style
      assert_equal "datetime_yy-m", f.key
    end

  end

end
