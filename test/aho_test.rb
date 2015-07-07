require 'helper'

class AhoTest < MiniTest::Test

  def setup
    @first_text = "Hello World"
    @second_text = "World Hello"
    @ngram = 2
    @matcher = Aho.new(first_text: @first_text, second_text: @second_text, ngram: @ngram)
  end

  def text_first_text
    assert_equal @matcher.first_text, @first_text
  end

  def text_second_text
    assert_equal @matcher.second_text, @second_text
  end

  def test_ngram
    assert_equal @matcher.ngram, @ngram
  end

  def test_first_text_ngram
    assert_equal @matcher.first_text_ngram, @first_text.to_ngram(@ngram)
  end

  def test_second_text_ngram
    assert_equal @matcher.second_text_ngram, @second_text.to_ngram(@ngram)
  end

  def test_first_text_match_pattern
  end

  def test_second_text_match_pattern
  end

  def test_similar_matching_pattern
  end

  def test_coeffision_similarity
  end

  def test_as_hash
  end
end
