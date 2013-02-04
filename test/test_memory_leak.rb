require 'helper'

class TestMemoryLeak < Test::Unit::TestCase
  should "not leak the proxy class" do
    ids = 2.times.map do
      user = User.new
      user.has_warnings?
      user.instance_variable_get(:@warnings).class.object_id
    end

    assert_equal ids[0], ids[1]
  end
end
