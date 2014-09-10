require 'helper'

class RobinKarpTest < MiniTest::Test

  def setup
    @first_text = "Hello World"
    @second_text = "World Hello"
    @ngram = 3
    @matcher = RobinKarp.new first_text: @first_text, second_text: @second_text, ngram: @ngram
  end

  def test_have_method_first_text
    assert_respond_to @matcher, :first_text
  end

  def test_have_method_second_text
    assert_respond_to @matcher, :second_text
  end

  def test_ngram
    assert_equal @ngram, @matcher.ngram
  end
  def test_ngram_method
    assert_respond_to @matcher, :ngram
  end

  def test_first_text
    assert_equal @matcher.first_text, @first_text
  end

  def test_second_text
    assert_equal @matcher.second_text, @second_text
  end

  def test_first_text_hash
    assert_kind_of Array, @matcher.first_text_hashes
  end

  def test_second_text_hash
    assert_kind_of Array, @matcher.second_text_hashes
  end

  def test_first_text_fingerprints
    assert_kind_of Array, @matcher.first_text_fingerprints
  end

  def test_second_text_fingerprints
    assert_kind_of Array, @matcher.second_text_fingerprints
  end
end
