require 'helper'

class TestAssociations < TestCase
  def test_active_record_associations_validation
    user = User.new
    user.books << Book.new(isbn: '')
    assert user.has_alerts?
    assert_equal user.alerts.full_messages, ['Books is invalid']
    assert user.books.first.has_alerts?
  end
end
