require "helper"

class BoyerMooreTest < Minitest::Test

  def test_result
    assert_equal 0, BoyerMoore.new("Hello World Hello", "Hello").result
    assert_equal 0, BoyerMoore.new("ANPANMAN", "ANP").result
    assert_equal nil, BoyerMoore.new("ANPANMAN", "ANPXX").result
    assert_equal 5, BoyerMoore.new("ANPANMAN", "MAN").result
    assert_equal 3, BoyerMoore.new("foobar", "bar").result
    haystack = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    needle = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    assert_equal 75, BoyerMoore.new(haystack, needle).result
  end

end
