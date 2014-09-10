require 'helper'


class StringTest < Minitest::Test

  def test_ngrma_when_not_giving_params
    assert_equal ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"], "Hello World".to_ngram
  end

  def test_ngram_when_string_size_more_than_one
    assert_equal ["He", "el", "ll", "lo", "o ", " W", "Wo", "or", "rl", "ld"], "Hello World".to_ngram(2)
  end

  def test_ngram_when_params_size_is_more_than_string_size
    assert_equal ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"], "Hello World".to_ngram(20)
  end

  def test_ngram_when_sting_size_is_one
    assert_equal ["H"], "H".to_ngram
    assert_equal ["H"], "H".to_ngram(3)
  end

  def test_base11_hash_when_no_string_given
    assert_equal 0, "".base11_hash
  end

  def test_base11_hash_when_given_string
    assert_equal 13031, "aku".base11_hash
  end

  def test_boyer_moore_badcharacter_heuristic
    # Hello World is 11 char
    hash = {
      "H" => 0,
      "e" => 1,
      "l" => 9,
      "o" => 7,
      " " => 5,
      "W" => 6,
      "r" => 8,
      "d" => 10
    }
    assert_equal hash, "Hello World".to_boyer_moore_badcharacter_heuristic
  end

  # def test_booyer_moore_badcharacter_heuristic_no_zero_value
  #   boyer_moore_badcharacter = "roadrunner".to_boyer_moore_badcharacter_heuristic
  #   refute boyer_moore_badcharacter.has_value?(0)
  # end

  def test_boyer_moore_prefix
    assert_equal [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Hello World".to_boyer_moore_suffixes
  end

  def test_boyer_moore_goodsuffix_heuristic
    assert_equal [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 1], "Hello World".to_boyer_moore_goodsuffix_heuristic
  end
end
