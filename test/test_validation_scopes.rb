require 'helper'

class TestValidationScopes < Test::Unit::TestCase
  context "A model with warnings and alerts" do
    setup do
      @user = User.find(1)
    end

    should "have warnings defined" do
      assert_nothing_raised { @user.warnings }
    end

    should "check for warnings and find none" do
      assert ! @user.has_warnings?
      assert @user.no_warnings?
    end

    should "raise warning if age set negative" do
      @user.age = -1
      assert @user.has_warnings?
      assert @user.warnings[:age].any?
    end

    should "raise warning for inline validation" do
      @user.sponsor_id = 12345
      assert @user.has_warnings?
      assert @user.warnings[:sponsor_id].any?
    end

    should "not add warning to main errors instance" do
      @user.email = ''
      assert @user.has_warnings?
      assert @user.valid?
      assert @user.errors.empty?
    end

    should "not add errors to the warnings instance" do
      @user.name = ''
      assert @user.invalid?
      assert @user.warnings.empty?
    end

    context "validating alerts with a private method" do
      setup do
        @user.age = 100
        @user.email = "zappa@hotmail.com"
      end

      should "set alerts but not errors" do
        assert @user.has_alerts?, "no alerts raised"
        assert @user.alerts[:base], "centenarian alert not raised"
        assert @user.alerts[:email], "hotmail alert not raised"
        assert @user.valid?, "user not valid"
        assert @user.errors.empty?, "user errors not empty"
      end
    end
  end

end
