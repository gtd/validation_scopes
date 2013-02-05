require 'helper'

class TestMemoryLeak < MiniTest::Unit::TestCase
  def test_should_not_leak_proxy_class
    ids = 2.times.map do
      user = User.new
      user.has_warnings?
      user.instance_variable_get(:@warnings).class.object_id
    end

    assert_equal ids[0], ids[1]
  end
end
