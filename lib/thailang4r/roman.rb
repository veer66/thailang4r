# coding: utf-8

require_relative 'word_breaker'

module ThaiLang
  # Ported from https://github.com/PyThaiNLP/pythainlp/blob/dev/pythainlp/transliterate/royin.py (be1265d)
  class Royin
    vowel_patterns = """เ*ียว,\\1iao
แ*็ว,\\1aeo
เ*ือย,\\1ueai
แ*ว,\\1aeo
เ*็ว,\\1eo
เ*ว,\\1eo
*ิว,\\1io
*วย,\\1uai
เ*ย,\\1oei
*อย,\\1oi
โ*ย,\\1oi
*ุย,\\1ui
*าย,\\1ai
ไ*ย,\\1ai
*ัย,\\1ai
ไ**,\\1\\2ai
ไ*,\\1ai
ใ*,\\1ai
*ว*,\\1ua\\2
*ัวะ,\\1ua
*ัว,\\1ua
เ*ือะ,\\1uea
เ*ือ,\\1uea
เ*ียะ,\\1ia
เ*ีย,\\1ia
เ*อะ,\\1oe
เ*อ,\\1oe
เ*ิ,\\1oe
*อ,\\1o
เ*าะ,\\1o
เ*็,\\1e
โ*ะ,\\1o
โ*,\\1o
แ*ะ,\\1ae
แ*,\\1ae
เ*าะ,\\1e
*าว,\\1ao
เ*า,\\1ao
เ*,\\1e
*ู,\\1u
*ุ,\\1u
*ื,\\1ue
*ึ,\\1ue
*ี,\\1i
*ิ,\\1i
*ำ,\\1am
*า,\\1a
*ั,\\1a
*ะ,\\1a
#ฤ,\\1rue
$ฤ,\\1ri"""

    VOWELS = vowel_patterns.gsub("*", "([ก-ฮ])")
               .gsub("#", "([คนพมห])")
               .gsub("$", "([กตทปศส])")
               .split("\n")
               .map {_1.split(",")}
               .map {[Regexp.new(_1), _2]}
  
    # พยัญชนะ ต้น สะกด
    CONSONANTS = {
      "ก" => ["k", "k"],
      "ข" => ["kh", "k"],
      "ฃ" => ["kh", "k"],
      "ค" => ["kh", "k"],
      "ฅ" => ["kh", "k"],
      "ฆ" => ["kh", "k"],
      "ง" => ["ng", "ng"],
      "จ" => ["ch", "t"],
      "ฉ" => ["ch", "t"],
      "ช" => ["ch", "t"],
      "ซ" => ["s", "t"],
      "ฌ" => ["ch", "t"],
      "ญ" => ["y", "n"],
      "ฎ" => ["d", "t"],
      "ฏ" => ["t", "t"],
      "ฐ" => ["th", "t"],
      # ฑ พยัญชนะต้น เป็น d ได้
      "ฑ" => ["th", "t"],
      "ฒ" => ["th", "t"],
      "ณ" => ["n", "n"],
      "ด" => ["d", "t"],
      "ต" => ["t", "t"],
      "ถ" => ["th", "t"],
      "ท" => ["th", "t"],
      "ธ" => ["th", "t"],
      "น" => ["n", "n"],
      "บ" => ["b", "p"],
      "ป" => ["p", "p"],
      "ผ" => ["ph", "p"],
      "ฝ" => ["f", "p"],
      "พ" => ["ph", "p"],
      "ฟ" => ["f", "p"],
      "ภ" => ["ph", "p"],
      "ม" => ["m", "m"],
      "ย" => ["y", ""],
      "ร" => ["r", "n"],
      "ฤ" => ["rue", ""],
      "ล" => ["l", "n"],
      "ว" => ["w", ""],
      "ศ" => ["s", "t"],
      "ษ" => ["s", "t"],
      "ส" => ["s", "t"],
      "ห" => ["h", ""],
      "ฬ" => ["l", "n"],
      "อ" => ["", ""],
      "ฮ" => ["h", ""],
    }

    def normalize(word)
      word.gsub(/จน์|มณ์|ณฑ์|ทร์|ตร์|[ก-ฮ]์|[ก-ฮ]ะ-ู์|[ฯๆ่-๏๚๛]/, "")
    end

    def replace_vowel(word)
      VOWELS.each { word.gsub!(_1, _2) }
      return word
    end

    def replace_consonants(word, consonants)
      return word unless consonants
      return word.gsub(consonants[0], CONSONANTS[consonants[0]][0]) if consonants.length == 1
      consonants.reduce({rom: "", th: word}) do |w, consonant|
        non_thai = w[:th].match(/^[^ก-์]+/)
        if non_thai
          w[:rom] += non_thai.to_s
          w[:th] = w[:th][non_thai.to_s.length..-1]
        end
        if w[:skip]
          {rom: w[:rom], th: w[:th]}
        elsif w[:rom] == "" and w[:th] == "ห"
          {rom: "", th: w[:th][1..-1]}
        elsif w[:rom] == ""
          {rom: CONSONANTS[consonant][0], th: w[:th][consonant.length..-1]}
        elsif consonant == "ร" and w[:th] == "รร"
          {rom: w[:rom] + "an", th: w[:th][2..-1], skip: true}
        elsif consonant == "ร" and w[:th][0..1] == "รร"
          {rom: w[:rom] + "a", th: w[:th][2..-1], skip: true}
        else
          {rom: w[:rom] + CONSONANTS[consonant][1], th: w[:th][consonant.length..-1]}
        end
      end[:rom]
    end
    
    def romanize_word(word)
      word = replace_vowel(normalize(word))
      consonants = word.scan(/[ก-ฮ]/)
      if word.length == 2 and consonants.length == 2
        word = word.chars
        word.insert(1, "o")
        word = word.join("")      
      end
      word = replace_consonants(word, consonants)
      return word
    end

    WORDCUT = WordBreaker.new
  
    def romanize(text, delim = "")
      WORDCUT.break_into_words(text).map { romanize_word _1 }.join(delim)
    end
  end
end
