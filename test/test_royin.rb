# coding: utf-8

require 'test/unit'
require_relative '../lib/thailang4r/roman.rb'

class RoyinTest < Test::Unit::TestCase
  def setup
    @royin = ThaiLang::Royin.new
  end

   def test_simple    
     assert_equal "ka", @royin.romanize("กา")
   end

  def test_two_words_and_delim
    assert_equal "ka ka", @royin.romanize("กากา", delim = " ")
  end

  def test_kan
    assert_equal "kan", @royin.romanize("การ")
  end

  def test_complex_word
    assert @royin.romanize("อานิสงส์").length > 0
  end

  def test_long
    assert @royin.romanize("อานิสงส์ของการได้ยินได้ฟังพุทธวจนก่อนตาย เป็นอย่างไร").length > 0
  end

  def test_hum
    assert_equal "ham", @royin.romanize("หำ")
  end

  def test_rr_end
    assert_equal "khan", @royin.romanize("ขรร")
  end

end
