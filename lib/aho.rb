require 'aho_corasick'
class Aho

  attr_reader :first_text, :second_text, :ngram

  def initialize args = {}
    @first_text ||= args[:first_text]
    @second_text ||= args[:second_text]
    @ngram ||= args[:ngram] || 2
  end

  def first_text_ngram
    @first_text_ngram ||= first_text.to_ngram(ngram)
  end

  def second_text_ngram
    @second_text_ngram ||= second_text.to_ngram(ngram)
  end

  def first_text_match_pattern
    aho_corasick = AhoCorasick.new second_text_ngram
    matchers = aho_corasick.match(first_text)
    return matchers
  end

  def second_text_match_pattern
    aho_corasick = AhoCorasick.new first_text_ngram
    matchers = aho_corasick.match(second_text)
    return matchers
  end

  def similar_matching_pattern
    first_text_match_pattern & second_text_match_pattern
  end

  def coeffision_similarity
    ((2.0 * similar_matching_pattern.size.to_f) / ((first_text_match_pattern.uniq.size.to_f + second_text_ngram.uniq.size.to_f))) * 100.0
  end

  def as_hash
    {
      first_text: first_text,
      second_text: second_text,
      ngram: ngram,
      first_text_ngram: first_text_ngram,
      second_text_ngram: second_text_ngram,
      first_text_match_pattern: first_text_match_pattern,
      second_text_match_pattern: second_text_match_pattern,
      similar_matching_pattern: similar_matching_pattern,
      coeffision_similarity: coeffision_similarity
    }
  end

end
