thailang4r
==========
Thai language utility for Ruby

I have built this project in order to collect and share tools for Thai language, which are written in Ruby language. 

* chlevel is similar th_chlevel in [libthai](http://linux.thai.net/projects/libthai).
* string_chlevel gives array of level back for example string_chlevel("กี") will return [1, 2]

Word breaker
------------
```ruby
# encoding: UTF-8
require 'thailang4r/word_breaker'
word_breaker = ThaiLang::WordBreaker.new
puts word_breaker.break_into_words("ฉันกินข้าว")
```
