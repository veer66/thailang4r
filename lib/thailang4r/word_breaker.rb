require 'rubygems'
require 'thailang4r/dict.rb'
require 'thailang4r/word_dag_builder.rb'
require 'thailang4r/ranges_builder.rb'

module ThaiLang
  class WordBreaker

    S = 0
    E = 1

    def initialize(path = nil)
      if path.nil?
        path = File.expand_path('../../../data/tdict-std.txt', __FILE__)
      end
      @dict = Dict.new path
      @dag_builder = WordDagBuilder.new @dict
      @ranges_builder = RangesBuilder.new
    end

    def break_into_words(string)
      len = string.length
      dag = @dag_builder.build(string, len)
      ranges = @ranges_builder.build_from_dag(dag, len)
      ranges.map{|range| string[range[S], range[E] - range[S]]}
    end
  end
end
