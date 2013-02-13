module ThaiLang
  def ThaiLang.string_chlevel(s)
    ch_level_list = []
    s.each_char do |ch|
      ch_level_list << chlevel(ch)
    end
    ch_level_list
  end
  
  def ThaiLang.chlevel(ch)
    _chlevel(ch.ord)
  end
  
  def ThaiLang._chlevel(code)
    level = nil    
    if (code >= 0x0E01 and code <= 0x0E30) or
       (code >= 0x0E32 and code <= 0x0E33) or
       (code >= 0x0E3F and code <= 0x0E46) or
       (code >= 0x0E4F and code <= 0x0E5B) then
      level = 1
    elsif (code >= 0x0E38 and code <= 0x0E3A) then
      level = -1
    elsif code == 0x0E31 or
            (code >= 0x0E34 and code <= 0x0E37) or
            (code >= 0x0E4C and code <= 0x0E4E) then
      level = 2
    elsif code >= 0x0E48 and code <= 0x0E4B then
      level = 3
    end
    level
  end
  
  def ThaiLang.exclude_thai_lower_upper(s)
    included_list = []
    s.each_char do |ch|
      if chlevel(ch).nil? or chlevel(ch) == 1
        included_list << ch
      end
    end
    included_list.join('')
  end
end
