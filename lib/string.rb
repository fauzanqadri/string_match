# extend string object on ruby since ruby paradigm is `Everything is Object`
# so we can easly extend every object in ruby like this
#
# n-gram is a contiguous sequence of n items from a given sequence of text or speech. 
# The items can be phonemes, syllables, letters, words or base pairs according to the application. 
# The n-grams typically are collected from a text or speech corpus.
# so heres example how we implment n-grams in ruby
#
# given string "Hello World" just call `to_ngram` from string object "Hello World"
# "Hello World".to_ngram
# => ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"]
# not satisfied only with unigram result ?, let's try it out something like this
# "Hello World".to_ngram(2)
# => ["He", "el", "ll", "lo", "o ", " W", "Wo", "or", "rl", "ld"]
# yapp, you can pass Fixnum as argument to `to_ngram` methods
#
# what if the string is only 1 char, let's try it out
# "H".to_ngram
# => ["H"]
#
# Hmmm, let's try out something like this
# "Hello World".to_ngram(10000)
# => ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"] # pretty cool, huh?
#
# so if the character inside string is smaller then argument you've given to `to_ngram` method the argument will ignored
#
#
# next things is let's count of base 110 hash from a string
# "aku".base11_hash
# => 13031 # it's depending your computer to count it
#
# how about we doing something like this
# "".base11_hash
# => 0
# it's null string, it's different from white space
# " ".base11_hash
# => "32" # base on my computer
class String

  def to_ngram size = 1
    return [self[0]] if self.size == 1
    size = self.size < size ? 1 : size
    (0..self.size - size).map do |index|
      "#{self[index, size]}"
    end
  end

  def base11_hash
    hash_count = 0
    self.size.times do |index|
      ascii = self[index].ord
      hash_count += ascii * (11 ** (self.size - (index + 1)))
    end
    hash_count
  end

  def to_boyer_moore_badcharacter_heuristic
    # (0...(self.size)).inject({}){|hash, i| hash[self[i]] = (self.size - i - 1); hash}
    (0...(self.size)).inject({}){|hash, i| hash[self[i]] = i; hash}
  end

  def to_boyer_moore_suffixes
    k = 0
    1.upto((self.size - 1)).inject([0]) do |hash, i|
      while (k > 0) && (self[k] != self[i])
        k = hash[k-1]
      end
      k += 1 if self[k] == self[i]
      hash << k
    end
  end

  def to_boyer_moore_goodsuffix_heuristic
    reversed = self.dup.reverse
    result = []
    prefix_normal = self.to_boyer_moore_suffixes
    prefix_reversed = reversed.to_boyer_moore_suffixes

    0.upto(self.size) do |i|
      result[i] = size - prefix_normal[size-1]
    end

    0.upto(self.size - 1) do |i|
      j = self.size - prefix_reversed[i]
      k = i - prefix_reversed[i]+1
      result[j] = k if result[j] > k
    end
    result
  end
end
