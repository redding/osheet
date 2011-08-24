require "assert"
require 'osheet/format/datetime'

module Osheet::Format

  class DatetimeTest < Assert::Context
    desc "Datetime format"

    should "generate a basic style string and key" do
      f = Datetime.new 'mm/dd/yyyy'
      assert_equal "mm/dd/yyyy", f.style
      assert_equal "datetime_mm/dd/yyyy", f.key
    end

    should "generate a more complex style string and key" do
      f = Datetime.new 'yy-m'
      assert_equal 'yy-m', f.style
      assert_equal "datetime_yy-m", f.key
    end
  end

end
