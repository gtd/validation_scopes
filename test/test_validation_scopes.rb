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
      assert @user.warnings.on(:age)
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
      end

      should "set alerts but not errors" do
        assert @user.has_alerts?
        assert @user.alerts.on(:base)
        assert @user.valid?
        assert @user.errors.empty?
      end
    end
  end

end
