require_relative 'string'
class BoyerMoore
  attr_reader :haystack, :needle


  def initialize haystack, needle
    @haystack ||= haystack
    @needle ||= needle
  end

  def bad_character
    @bad_character ||= needle.to_boyer_moore_badcharacter_heuristic
  end

  def good_suffix
    @good_suffix ||= needle.to_boyer_moore_goodsuffix_heuristic
  end


  def result
    @result ||= find_location
  end

  def similarities
    return 0 unless result
    div = needle.size.to_f / haystack.size.to_f
    (div * 100.to_f).round(2)
  end

  private

    def find_location
      match_locations = 0
      while match_locations <= haystack.size - needle.size
        needle_counter = needle.size
        while(needle_counter > 0) && (needle[needle_counter-1].eql?(haystack[match_locations + needle_counter - 1]))
          needle_counter -= 1
        end
        if needle_counter > 0
          k = bad_character[haystack[match_locations+needle_counter-1]]
          k = -1 unless k
          if (k < needle_counter) && (m = needle_counter-k-1) > good_suffix[needle_counter]
            match_locations += m
          else
            match_locations += good_suffix[needle_counter]
          end
        else
          return match_locations
        end
      end
    end
end

haystack = "The red fox, Vulpes vulpes, is the largest of the true foxes and the most abundant wild member of the Carnivora, being present across the entire Northern Hemisphere from the Arctic Circle to North Africa"
needle = "the largest of the truo"
moore = BoyerMoore.new(haystack, needle)
