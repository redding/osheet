require "assert"
require 'osheet/format/special'

class Osheet::Format::Special

  class UnitTests < Assert::Context
    desc "Osheet::Format::Special"
    before{ @sp = Osheet::Format::Special.new }
    subject{ @sp }

    should have_accessors :type

    should "provide options for type" do
      assert_equal 4, Osheet::Format::Special.type_set.size
      [ :zip_code, :zip_code_plus_4, :phone_number, :social_security_number].each do |a|
        assert Osheet::Format::Special.type_set.include?(a)
      end
    end

    should "set default values" do
      assert_equal nil, subject.type
      assert_equal nil, subject.type_key
    end

    should "generate a zip_code type style strings and key" do
      f = Osheet::Format::Special.new(:type => :zip_code)
      assert_equal "00000", f.style
      assert_equal "special_zipcode", f.key
    end

    should "generate a zip_code_plus_4 type style strings and key" do
      f = Osheet::Format::Special.new(:type => :zip_code_plus_4)
      assert_equal "00000-0000", f.style
      assert_equal "special_zipcodeplus4", f.key
    end

    should "generate a phone_number type style strings and key" do
      f = Osheet::Format::Special.new(:type => :phone_number)
      assert_equal "[<=9999999]###-####;(###) ###-####", f.style
      assert_equal "special_phonenumber", f.key
    end

    should "generate a social_security_number type style strings and key" do
      f = Osheet::Format::Special.new(:type => :social_security_number)
      assert_equal "000-00-0000", f.style
      assert_equal "special_socialsecuritynumber", f.key
    end

  end

end
