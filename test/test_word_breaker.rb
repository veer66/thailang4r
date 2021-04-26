# coding: utf-8
require 'test/unit'
require_relative '../lib/thailang4r/word_breaker.rb'

class WordBreakerTest < Test::Unit::TestCase
  def setup
    @wbrk = ThaiLang::WordBreaker.new
  end

  def test_simple
    assert_equal ["ฉัน", "กิน", "ข้าว"], @wbrk.break_into_words("ฉันกินข้าว")
  end
end
