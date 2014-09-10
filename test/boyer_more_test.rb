require "helper"

class BoyerMooreTest < Minitest::Test

  def setup
    @matcher = BoyerMoore.new "Hello World", "World"
  end

  def test_result
    assert_equal 6, @matcher.result
  end
end
