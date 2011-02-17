require "test/helper"

class Osheet::WorksheetTest < Test::Unit::TestCase

  context "Osheet::Worksheet" do
    subject { Osheet::Worksheet.new }

    should_have_instance_methods :name, :workbook
    should_have_instance_methods :columns, :column
    should_have_instance_methods :rows, :row

    should "default it's name to nil" do
      assert subject.name.nil?
    end

    context "that is named" do
      subject { Osheet::Worksheet.new "Poo" }

      should "should know it's name" do
        assert_equal "Poo", subject.name
      end
    end

  end

end
