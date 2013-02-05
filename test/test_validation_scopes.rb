require 'helper'

class TestValidationScopes < MiniTest::Unit::TestCase
  def setup
    @user = User.find(1)
  end

  def test_warnings_definition
    assert @user.warnings, "warnings was not defined"
  end

  def test_empty_warnings
    assert ! @user.has_warnings?
    assert @user.no_warnings?
  end

  def test_a_warning
    @user.age = -1
    assert @user.has_warnings?
    assert @user.warnings[:age].any?
  end

  def test_an_inline_warning
    @user.sponsor_id = 12345
    assert @user.has_warnings?
    assert @user.warnings[:sponsor_id].any?
  end

  def test_that_warnings_do_not_impact_main_errors
    @user.email = ''
    assert @user.has_warnings?
    assert @user.valid?
    assert @user.errors.empty?
  end

  def test_that_errors_do_not_impact_warnings
    @user.name = ''
    assert @user.invalid?
    assert @user.warnings.empty?
  end

  def test_multiple_scopes
    @user.age = 100
    @user.email = "zappa@hotmail.com"

    assert @user.has_alerts?, "no alerts raised"
    assert @user.alerts[:base], "centenarian alert not raised"
    assert @user.alerts[:email], "hotmail alert not raised"
    assert @user.valid?, "user not valid"
    assert @user.errors.empty?, "user errors not empty"
  end

  def test_proxy_returns_self_for_to_model
    # Because error_messages_for in dynamic_model gem calls this and delegation
    # causes base object to be returned, thus losing scoped errors.
    assert_equal @user.validation_scope_proxy_for_warnings.class,
                 @user.validation_scope_proxy_for_warnings.to_model.class
  end

  def test_proxy_returns_model_name_of_base_class
    assert_equal 'User',
                 @user.validation_scope_proxy_for_warnings.class.model_name
  end

  def test_all_scopes
    assert_equal [:warnings, :alerts], User.all_scopes
    assert_equal [:warnings_book, :alerts_book], Book.all_scopes
  end
end
