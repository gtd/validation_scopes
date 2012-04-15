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

  context "proxy class" do
    setup do
      @user = User.find(1)
    end

    # Because error_messages_for in dynamic_model gem calls this and delegation
    # causes base object to be returned, thus losing scoped errors.
    should "return self for to_model" do
      assert_equal @user.validation_scope_proxy_for_warnings.class,
                   @user.validation_scope_proxy_for_warnings.to_model.class
    end

    should "return model_name of base_class" do
      assert_equal 'User',
                   @user.validation_scope_proxy_for_warnings.class.model_name
    end
  end

  context "scopes per model" do
    setup do
      @user = User.find(1)
      @book = Book.find(1)
      @book2 = Book.find(2)
    end

    should "return all the scopes declared in User model" do
      assert_equal [:warnings, :alerts], @user.class.all_scopes 
    end

    should "return all the scopes declared in Book model" do
      assert_equal [:warnings_book, :alerts_book], @book.class.all_scopes 
      assert_equal [:warnings_book, :alerts_book], @book2.class.all_scopes 
    end
  end
end
