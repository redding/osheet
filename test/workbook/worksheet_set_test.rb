require "assert"

require "osheet/workbook/worksheet_set"

module Osheet
  class WorksheetSetTest < Assert::Context
    desc "a WorksheetSet"
    before { @set = Workbook::WorksheetSet.new }
    subject { @set }

    should "be an Array" do
      assert_kind_of ::Array, subject
    end

    should "verify Worksheet objs" do
      assert_raises ArgumentError do
        subject.send(:verify, {})
      end
      assert_nothing_raised do
        subject.send(:verify, Worksheet.new {})
      end
    end

  end

end
