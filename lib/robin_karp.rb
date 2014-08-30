class RobinKarp
  attr_reader :first_text, :second_text, :ngram

  def initialize options = {}
    @first_text ||= options[:first_text]
    @second_text ||= options[:second_text]
    @ngram ||= options[:ngram] || 2
  end

  def first_text_hashes
    @first_text_hashes ||= rolling_hash first_text.downcase
  end

  def second_text_hashes
    @second_text_hashes ||= rolling_hash second_text.downcase
  end

  def first_text_fingerprints
    @first_text_fingerprints ||= check_fingerprint first_text_hashes
  end

  def second_text_fingerprints
    @second_text_fingerprints ||= check_fingerprint second_text_hashes
  end

  def similar_fingerprint
    fingerprints = []
    first_text_fingerprints.each do |first_text_fingerprint|
      second_text_fingerprints.each do |second_text_fingerprint|
        fingerprints << first_text_fingerprint if first_text_fingerprint == second_text_fingerprint
      end
    end
    fingerprints
  end

  def coeffision_similarity
    ((2.0 * similar_fingerprint.size.to_f) / ((first_text_fingerprints.size.to_f + second_text_fingerprints.size.to_f))) * 100.0
  end


  def check_fingerprint hashes
    fingerprints = []
    done = false
    hashes.each do |hash|
      unless fingerprints.empty?
        fingerprints.each do |fingerprint|
          if fingerprint == hash
            done = true
          end
        end
      end
      fingerprints << hash unless done
      done = false
    end
    fingerprints
  end

  def rolling_hash text
    text.to_ngram(ngram).map{|ngram| ngram.base11_hash}
  end

  private :rolling_hash, :check_fingerprint
end
