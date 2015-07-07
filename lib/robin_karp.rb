class RobinKarp
  attr_reader :first_text, :second_text, :ngram

  def initialize options = {}
    @first_text ||= options[:first_text]
    @second_text ||= options[:second_text]
    @ngram ||= options[:ngram] || 2
  end

  def first_text_ngram
    @first_text_ngram ||= first_text.downcase.to_ngram(ngram)
  end

  def second_text_ngram
    @second_text_ngram ||= second_text.downcase.to_ngram(ngram)
  end

  def first_text_hashes
    @first_text_hashes ||= rolling_hash first_text_ngram
  end

  def second_text_hashes
    @second_text_hashes ||= rolling_hash second_text_ngram
  end

  def first_text_fingerprints
    @first_text_fingerprints ||= first_text_hashes.uniq
  end

  def second_text_fingerprints
    @second_text_fingerprints ||= second_text_hashes.uniq
  end

  def similar_fingerprint
    first_text_fingerprints & second_text_fingerprints
  end

  def coeffision_similarity
    ((2.0 * similar_fingerprint.size.to_f) / ((first_text_fingerprints.size.to_f + second_text_fingerprints.size.to_f))) * 100.0
  end

  def as_hash
    {
      first_text: first_text,
      second_text: second_text,
      ngram: ngram,
      first_text_ngram: first_text_ngram,
      second_text_ngram: second_text_ngram,
      first_text_hashes: first_text_hashes,
      second_text_hashes: second_text_hashes,
      first_text_fingerprints: first_text_fingerprints,
      second_text_fingerprints: second_text_fingerprints,
      similar_fingerprint: similar_fingerprint,
      coeffision_similarity: coeffision_similarity
    }
  end

  private

  def rolling_hash ngram_text
    ngram_text.map {|text| text.base11_hash }
  end
end
