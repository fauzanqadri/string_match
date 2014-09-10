class BoyerMoore
  attr_reader :haystack, :needle


  def initialize haystack, needle
    @haystack ||= haystack
    @needle ||= needle
  end


  def result
    return nil if haystack.size == 0
    return heystack if needle.size == 0
    badcharacter = needle.to_boyer_moore_badcharacter_heuristic
    goodsuffix = needle.to_boyer_moore_goodsuffix_heuristic
    s = 0
    while s <= haystack.size - needle.size
      j = needle.size
      while (j > 0) && needle_matches?(needle[j - 1], haystack[s + j - 1])
        j -= 1
      end
      if j > 0
        k = badcharacter[haystack[s+j-1]]
        k = -1 unless k
        if (k < j) && (m = j-k-1) > goodsuffix[j]
          s += m
        else
          s += goodsuffix[j]
        end
      else
        return s
      end
    end
    return nil
  end

  def needle_matches? needle, haystack
    needle == haystack
  end
end
