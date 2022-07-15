module ThaiLang
  LEVEL_ONE_RANGES =
    [(0x0E01..0x0E30),
     (0x0E32..0x0E33),
     (0x0E3F..0x0E46),
     (0x0E4F..0x0E5B)].freeze
  LEVEL_MINUS_ONE_RANGE = (0x0E38..0x0E3A).freeze
  LEVEL_TWO_RANGES = [(0x0E34..0x0E37), (0x0E4C..0x0E4E)].freeze
  LEVEL_TREE_RANGE = (0x0E48..0x0E4B).freeze

  def self.string_chlevel(string)
    string.chars.map { |char| chlevel(char) }
  end

  def self.chlevel(char)
    _chlevel(char.ord)
  end

  def self._chlevel(code)
    if LEVEL_ONE_RANGES.any? { |range| range.include? code }
      1
    elsif LEVEL_MINUS_ONE_RANGE.include? code
      -1
    elsif code == 0x0E31 || LEVEL_TWO_RANGES.any? { |range| range.include? code }
      2
    elsif LEVEL_TREE_RANGE.include? code
      3
    end
  end

  def self.exclude_thai_lower_upper(string)
    string.chars.select { |char| [nil, 1].include?(chlevel(char)) }.join
  end
end
